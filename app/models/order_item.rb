# == Schema Information
#
# Table name: order_items
#
#  box_id   :integer
#  id       :integer          not null, primary key
#  order_id :integer
#  paid     :boolean          default(FALSE)
#  status   :string(255)      default("active")
#

class OrderItem < ActiveRecord::Base

  belongs_to :box, :inverse_of => :order_item
  belongs_to :order, :inverse_of => :order_items

  validates_presence_of :box, :order, :status

  def empty_box_delivered
    OrderMailer.empty_box_delivered(id).deliver
    self.status = "empty_box_delivered"
    self.save
  end

  def full_box_shipped
    if paid
      raise "This user has already been paid"
    else
      if box.user.credit_account(box.seller_price * 0.8)
        OrderMailer.full_box_shipped(id).deliver
        self.paid = true
        self.status = "full_box_shipped"
        self.save
        box.user.save
      end
    end
  end

  def full_box_delivered
    OrderMailer.full_box_delivered(id).deliver
    self.status = "full_box_delivered"
    self.save
  end
end
