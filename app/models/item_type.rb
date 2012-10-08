class ItemType
  include Mongoid::Document

  field :name
  field :category

  has_many :items

  validates_presence_of :name, :category
end