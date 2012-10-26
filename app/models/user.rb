# == Schema Information
#
# Table name: users
#
#  address                :hstore
#  authentication_token   :string(255)
#  birthday               :date
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  created_at             :datetime         not null
#  credits                :integer
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  fb_secret              :string(255)
#  fb_token               :string(255)
#  fb_uid                 :string(255)
#  fb_use_image           :boolean
#  gender                 :string(255)
#  id                     :integer          not null, primary key
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  name                   :string(255)
#  origin                 :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0)
#  slug                   :string(255)
#  stripe_customer_id     :string(255)
#  unconfirmed_email      :string(255)
#  updated_at             :datetime         not null
#  username               :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  extend FriendlyId
  friendly_id :username, :use => :slugged

  has_attachment :avatar, :accept => [:jpg, :jpeg, :png, :gif]

  has_one :cart, :dependent => :destroy, :inverse_of => :user
  has_many :items, :inverse_of => :user
  has_many :boxes, :inverse_of => :user
  has_many :orders, :inverse_of => :user

  validates_presence_of :name, :email, :encrypted_password
  attr_accessible :username, :name, :email, :password, :password_confirmation, :remember_me, :created_at, :updated_at

  after_create :initiate_cart

  def initiate_cart
    self.create_cart if cart.nil?
  end

  def admin?
    false #TODO: implement
  end

  def stripe
    stripe_customer_id ? Stripe::Customer.retrieve(stripe_customer_id) : nil
  end

  def update_stripe(stripe_token)
    customer = stripe
    if customer
      begin
        customer.card = stripe_token
        customer.save
      rescue => e
        return false
      end
    else
      # create a Customer
      begin
        customer = Stripe::Customer.create(
          :card => stripe_token,
          :description => email
        )
      rescue => e
        return false
      end
      self.stripe_customer_id = customer.id
    end

    true
  end

  def update_address(address)
    response = Stamps.clean_address(:address => address)
    if response[:valid?] == false
      false
    else
      self.address = response[:address]
    end
  end

  # Omniauth providers
  def self.find_by_omniauth(omniauth, signed_in_resource=nil, request_env=nil, referer=nil)
    new_user = false
    login = false
    info = omniauth['info']
    extra = omniauth['extra']['raw_info']

    existing_user = User.where(:fb_uid => omniauth['uid']).readonly(false).first
    # Try to get via email if user not found and email provided
    unless existing_user || !info['email']
      existing_user = User.where(:email => info['email']).first
    end

    if signed_in_resource && existing_user && signed_in_resource != existing_user
      user = signed_in_resource
      user.errors[:base] << "There is already a user with that account"
      return user, new_user
    elsif signed_in_resource
      user = signed_in_resource
    elsif existing_user
      user = existing_user
    end

    # If we found the user, update their token
    if user
      unless signed_in_resource
        login = true
      end
    else
      new_user = true
      if extra["gender"] && !extra["gender"].blank?
        gender = extra["gender"] == 'male' || extra["gender"] == 'm' ? 'm' : 'f'
      else
        gender = nil
      end

      user = User.new(
        :username => info['nickname'] ? info['nickname']  : "#{extra["first_name"]} #{extra["last_name"]}",
        :name => "#{extra["first_name"]} #{extra["last_name"]}",
        :gender => gender, :email => info["email"], :password => Devise.friendly_token[0,20]
      )
      user.birthday = Chronic.parse(extra["birthday"]) if extra["birthday"]
      user.origin = 'facebook'
    end

    # set the social info
    user.fb_uid = omniauth['uid']
    user.fb_secret = omniauth['credentials']['secret'] if omniauth['credentials'].has_key?('secret')
    user.fb_token = omniauth['credentials']['token']
    user.fb_use_image = true

    if user && !user.confirmed?
      user.confirm!
      #user.send_welcome_email #TODO
    end

    user.save if user

    if new_user && request_env
      referer_hash = { "Referer" => referer, "Referer Host" => referer == "none" ? "none" : URI(referer).host }
      #Resque.enqueue(MixpanelTrackEvent, "Signup", user.mixpanel_data.merge!(referer_hash), request_env.select{|k,v| v.is_a?(String) || v.is_a?(Numeric) })
    end

    if login == true && request_env
      #Resque.enqueue(MixpanelTrackEvent, "Login", user.mixpanel_data.merge!("Login Method" => omniauth['provider']), request_env.select{|k,v| v.is_a?(String) || v.is_a?(Numeric) })
    end

    return user, new_user
  end

end
