class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  embeds_many :order_items

  validates_presence_of :user, :order_items

  def add_box(box)
    self.order_items.build(:box => box)
  end

  def self.process(user)
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