class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  field :gender, type: String
  field :size, type: String
  field :brand, type: String
  field :new_with_tags, type: Boolean
  field :status, type: String, default: "active"

  belongs_to :user
  belongs_to :box
  belongs_to :item_type

  validates_presence_of :gender, :item_type, :size, :brand, :user, :new_with_tags
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
end
