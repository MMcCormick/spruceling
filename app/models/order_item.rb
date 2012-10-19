class OrderItem < ActiveRecord::Base

  belongs_to :box
  belongs_to :order

  validates_presence_of :box, :order

end