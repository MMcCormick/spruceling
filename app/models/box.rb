class Box
  include Mongoid::Document
  include Mongoid::Timestamps

  field :gender, :type => String
  field :size, :type => String
  field :level, :type => Integer
  field :items, :type => Hash
  field :pick_ids, :type => Array

  belongs_to :user

  validates_presence_of :gender, :size, :level
  attr_accessible :gender, :size, :level
end
