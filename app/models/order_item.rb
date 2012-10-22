# == Schema Information
#
# Table name: order_items
#
#  box_id   :integer
#  id       :integer          not null, primary key
#  order_id :integer
#

class OrderItem < ActiveRecord::Base

  belongs_to :box
  belongs_to :order, :inverse_of => :order_items

  validates_presence_of :box, :order

end
