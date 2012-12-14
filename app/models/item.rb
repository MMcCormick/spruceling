# == Schema Information
#
# Table name: items
#
#  box_id        :integer
#  brand_id      :integer
#  gender        :string(255)
#  id            :integer          not null, primary key
#  item_type_id  :integer
#  new_with_tags :boolean
#  photo         :string(255)
#  price         :decimal(8, 2)
#  size          :string(255)
#  status        :string(255)      default("active")
#  user_id       :integer
#

class Item < ActiveRecord::Base

  mount_uploader :photo, ImageUploader

  belongs_to :user, :inverse_of => :items
  belongs_to :box, :inverse_of => :items, :touch => true
  belongs_to :item_type, :inverse_of => :items
  belongs_to :brand, :inverse_of => :items

  validates :new_with_tags, :inclusion => {:in => [true, false]}
  attr_accessible :photo, :brand_id, :item_type_id, :new_with_tags, :gender, :size, :price
  validates_presence_of :gender, :item_type, :size, :brand, :user
  #TODO: validate type

  scope :active, where(:status => "active")

  def self.all_sizes
    ["12 months",
     "18 months",
     "24 months",
     "2T",
     "3T",
     "4T",
     "5T",
     "2",
     "3",
     "4",
     "5",
     "6",
     "6X",
     "7",
     "8",
     "9",
     "10",
     "11",
     "12",
     "14",
     "16",
     "18",
     "20",
     "Other"]
  end

  def weight
    item_type.item_weight.get_weight(size)
  end

  def type
    item_type.name
  end

  def type_singular
    if ["Pants", "Shorts"].include? item_type.category
      "Pair of #{item_type.name}"
    elsif item_type.name.include? "/"
      array = item_type.name.split(" / ")
      "#{array[0].singularize} / #{array[1].singularize}"
    else
      item_type.name.singularize
    end
  end

  def gender_noun
    {
      'm' => 'Boys',
      'f' => 'Girls',
      'u' => 'Unisex'
    }[gender]
  end
end
