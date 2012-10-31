# == Schema Information
#
# Table name: brands
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  name       :string(255)
#  updated_at :datetime         not null
#

class Brand < ActiveRecord::Base
  attr_accessible :name

  has_many :items, :inverse_of => :brand

  validates_uniqueness_of :name
end
