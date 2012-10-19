class ItemType < ActiveRecord::Base

  has_many :items
  belongs_to :item_weight

  validates_presence_of :name, :category, :item_weight

  def self.all_types
    result = {}
    ItemType.all.each do |type|
      result[type.category] ||= []
      result[type.category] << [type.short_name, type.id]
    end
    result
  end
end