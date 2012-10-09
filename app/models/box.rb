class Box
  include Mongoid::Document
  include Mongoid::Timestamps

  field :gender, :type => String
  field :size, :type => String

  belongs_to :user
  has_many :items

  validates_presence_of :gender, :size
  attr_accessible :gender, :size

  def add_item(item)
    if item.box || item.gender != gender || item.size != size
      false
    else
      self.items << item
    end
  end
end