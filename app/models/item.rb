class Item
  include Mongoid::Document
  field :gender, type: String
  field :size, type: String
  field :brand, type: String
  field :type, type: String

  belongs_to :user
  belongs_to :box
end
