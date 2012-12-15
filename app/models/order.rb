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

  @@spruceling_cut = BigDecimal("0.2")
  def self.spruceling_cut
    @@spruceling_cut
  end
  @@seller_cut = BigDecimal("0.7")
  def self.seller_cut
    @@seller_cut
  end
  @@charity_cut = BigDecimal("0.1")
  def self.charity_cut
    @@charity_cut
  end

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
        :amount => (price_total * 100).to_i,
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

  def self.generate(user, box)
    order = user.orders.build

    # must have payment info
    unless user.stripe
      order.errors.add :base, 'You must add payment information before you can process an order.'
      return order
    end

    # can't have an empty order
    unless box
      order.errors.add :base, 'You cannot process an order with no boxes.'
    end

    order.price_total = box.price_total + 10.00 - user.balance
    order.price_total = order.price_total < 0.5 ? 0.0 : order.price_total
    order.boxes_total = box.price_total

    order.add_box(box)

    order
  end
end
