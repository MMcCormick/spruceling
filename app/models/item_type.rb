# == Schema Information
#
# Table name: item_types
#
#  category       :string(255)
#  id             :integer          not null, primary key
#  item_weight_id :integer
#  name           :string(255)
#  short_name     :string(255)
#

class ItemType < ActiveRecord::Base

  has_many :items, :inverse_of => :item_type
  belongs_to :item_weight, :inverse_of => :item_types

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
