class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  field :gender, type: String
  field :size, type: String
  field :brand, type: String
  field :type, type: String

  belongs_to :user
  belongs_to :box

  validates_presence_of :gender, :type, :size, :brand

  def self.all_sizes
    ["12 months",
     "18 months",
     "2T",
     "3T",
     "4T",
     "5T",
     "6T",
     "7T",
     "8T"]
  end

  def self.all_types
    ["Capris",
     #"Dress Shirts"
     "Dresses",
     #"Gloves",
     "Hats",
     "Jackets",
     "Long-sleeved Shirts",
     "Pants",
     #"Polos",
     "Onesies",
     "Overalls",
     "Shorts",
     "Skirts",
     "Sweaters / Sweatshirts",
     "T-shirts"]
  end
end
