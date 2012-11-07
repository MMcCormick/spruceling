# == Schema Information
#
# Table name: orders
#
#  boxes_total      :decimal(8, 2)    not null
#  created_at       :datetime
#  id               :integer          not null, primary key
#  price_total      :decimal(8, 2)    not null
#  stripe_charge_id :string(255)
#  updated_at       :datetime
#  user_id          :integer
#

class Order < ActiveRecord::Base

  belongs_to :user, :inverse_of => :orders
  has_many :order_items, :inverse_of => :order
  has_many :boxes, :through => :order_items

  validates_presence_of :user, :price_total, :boxes_total
  validates :price_total, :numericality => {:greater_than_or_equal_to => 0.0, :less_than => 1000}
  validates :boxes_total, :numericality => {:greater_than => 1.0, :less_than => 1000}

  def add_box(box)
    self.order_items.build(:box => box)
  end

  def charge
    return false if stripe_charge_id #Already been charged

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

  def stripe_charge
    stripe_charge_id ? Stripe::Charge.retrieve(stripe_charge_id) : nil
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

  def send_confirmations
    OrderMailer.receipt(id).deliver
    senders = boxes.map{|box| box.user}
    senders.each do |sender|
      OrderMailer.sold(self.id, sender.id).deliver
    end
  end

  def self.generate(user)
    order = user.orders.build

    # must have payment info
    unless user.stripe
      order.errors.add :base, 'You must add payment information before you can process an order.'
      return order
    end

    # can't have an empty cart
    if user.cart.boxes.length == 0
      order.errors.add :base, 'You cannot process an order with an empty cart.'
      return order
    end

    order.price_total = user.cart.price_total
    order.boxes_total = user.cart.boxes_total
    user.cart.boxes.each do |b|
      order.add_box(b)
    end

    order
  end
end
