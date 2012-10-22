class Item < ActiveRecord::Base

  belongs_to :user, :inverse_of => :items
  belongs_to :box, :inverse_of => :items
  belongs_to :item_type, :inverse_of => :items

  validates :new_with_tags, :inclusion => {:in => [true, false]}
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
end
