# == Schema Information
#
# Table name: order_items
#
#  box_id   :integer
#  id       :integer          not null, primary key
#  order_id :integer
#  paid     :boolean          default(FALSE)
#

class OrderItem < ActiveRecord::Base

  belongs_to :box, :inverse_of => :order_item
  belongs_to :order, :inverse_of => :order_items

  validates_presence_of :box, :order

  def empty_box_delivered
    OrderMailer.empty_box_delivered(id).deliver
  end

  def full_box_shipped
    unless paid
      if box.user.credit_account(box.seller_price * 0.8)
        self.paid = true
        self.save
        box.user.save
      end
      OrderMailer.full_box_shipped(id).deliver
    end
  end

  def full_box_delivered
    OrderMailer.full_box_delivered(id).deliver
  end
end
