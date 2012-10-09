class ItemType
  include Mongoid::Document

  field :name
  field :category

  has_many :items

  validates_presence_of :name, :category

  def self.all_types
    result = {}
    ItemType.all.each do |type|
      result[type.category] ||= []
      result[type.category] << [type.name, type.id]
    end
    result
  end
end