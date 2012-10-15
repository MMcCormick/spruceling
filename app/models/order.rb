class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  field :stripe_charge_id, :type => String, :default => nil

  belongs_to :user
  embeds_many :order_items

  validates_presence_of :user, :order_items

  def add_box(box)
    self.order_items.build(:box => box)
  end

  def price_total
    order_items.length * 25
  end

  def charge
    begin
      charge = Stripe::Charge.create(
        :amount => price_total * 100,
        :currency => "usd",
        :customer => user.stripe.id,
        :description => "Charge for user #{user.email}"
      )
      self.stripe_charge_id = charge.id
    rescue => e
      return false
    end

    true
  end

  def process
    order_items.each do |o|
      user.cart.remove_box(o.box.id)
      o.box.status = 'sold'
      o.box.save
      o.box.items.each do |i|
        i.status = 'sold'
        i.save
      end
    end
  end

  def self.generate(user)
    order = user.orders.new

    # must have payment info
    unless user.stripe
      order.errors.add :user, 'You must add payment information before you can process an order.'
      return order
    end

    # can't have an empty cart
    if user.cart.boxes.length == 0
      order.errors.add :user, 'You cannot process an order with an empty cart.'
      return order
    end

    user.cart.boxes.each do |b|
      order.add_box(b)
    end

    order
  end
end