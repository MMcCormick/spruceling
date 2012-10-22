class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :cart, :dependent => :destroy, :inverse_of => :user
  has_many :items, :inverse_of => :user
  has_many :boxes, :inverse_of => :user
  has_many :orders, :inverse_of => :user

  validates_presence_of :name, :email, :encrypted_password
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :created_at, :updated_at

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

end
