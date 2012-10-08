class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  field :gender, type: String
  field :size, type: String
  field :brand, type: String

  belongs_to :user
  belongs_to :box
  belongs_to :item_type

  validates_presence_of :gender, :item_type, :size, :brand, :user
  #TODO: validate type

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
    {
      "Long-sleeve" => [
        "Sweaters",
        "Button Downs",
        "Polos",
        "T Shirts"
      ],
      "Short-sleeve" => [
        "Sweater Vests",
        "Button Downs",
        "Polos",
        "T Shirts",
        "Tank Tops"
      ],
      "Pants" => [
        "Jeans",
        "Chinos / Khakis",
        "Overalls",
        "Cords",
        "Capris",
        "Leggings",
        "Sweatpants / Windpants"
      ],
      "Shorts" => [
        "Khaki / Cotton",
        "Cargo",
        "Denim",
        "Overall"
      ],
    }
  end
end
