class OrderItem
  include Mongoid::Document

  belongs_to :box

  embedded_in :order

  validates_presence_of :box
end