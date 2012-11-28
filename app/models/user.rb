# == Schema Information
#
# Table name: users
#
#  address                :hstore
#  authentication_token   :string(255)
#  avatar                 :string(255)
#  balance                :decimal(8, 2)    default(0.0), not null
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
#  roles                  :string_array
#  sign_in_count          :integer          default(0)
#  slug                   :string(255)
#  stripe_customer_id     :string(255)
#  unconfirmed_email      :string(255)
#  updated_at             :datetime         not null
#  username               :string(255)
#

class User < ActiveRecord::Base
  serialize :address, ActiveRecord::Coders::Hstore

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  extend FriendlyId
  friendly_id :username, :use => :slugged

  mount_uploader :avatar, ImageUploader

  has_one :cart, :dependent => :destroy, :inverse_of => :user
  has_many :items, :inverse_of => :user
  has_many :boxes, :inverse_of => :user
  has_many :orders, :inverse_of => :user
  has_many :withdrawals, :inverse_of => :user

  validates_presence_of :name, :email, :encrypted_password, :balance
  attr_accessible :username, :name, :email, :password, :password_confirmation, :remember_me, :created_at, :updated_at

  attr_accessor :full_name, :address1, :address2, :city, :state, :zip_code

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
    begin
      response = Stamps.clean_address(:address => address)
      #response = {:valid? => false}
      if response[:valid?] == false
        return false
      else
        self.address = response[:address]
      end
    rescue Exception => e
      #notify_airbrake(e)
      logger.error"\n#{e.class} (#{e.message}):\n"
      self.address = address
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
      #referer_hash = { "Referer" => referer, "Referer Host" => referer == "none" ? "none" : URI(referer).host }
      #Resque.enqueue(MixpanelTrackEvent, "Signup", user.mixpanel_data.merge!(referer_hash), request_env.select{|k,v| v.is_a?(String) || v.is_a?(Numeric) })
    end

    if login == true && request_env
      #Resque.enqueue(MixpanelTrackEvent, "Login", user.mixpanel_data.merge!("Login Method" => omniauth['provider']), request_env.select{|k,v| v.is_a?(String) || v.is_a?(Numeric) })
    end

    return user, new_user
  end

  def credit_account(amount)
    if amount > 0
      self.balance = balance + amount
      true
    else
      false
    end
  end

  def withdraw_from_account(amount)
    if amount > 0 && amount <= balance
      self.balance = balance - amount
      true
    else
      false
    end
  end

  def rating
    avg = Box.select("AVG(rating) AS avg_rating").where("user_id = ? AND rating IS NOT NULL", id).group("user_id").first
    if avg
      avg.avg_rating.to_f
    else
      nil
    end
  end

  ###
  # ROLES
  ###

  # Checks to see if this user has a given role
  def role?(role)
    roles && roles.include?(role)
  end

  # Adds a role to this user
  def grant_role(role)
    self.roles ||= []
    self.roles << role unless self.roles.include?(role)
  end

  # Removes a role from this user
  def revoke_role(role)
    self.roles.delete(role) if roles
  end
end
