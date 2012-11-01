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

  after_create :add_to_soulmate

  def add_to_soulmate
    nugget = {
      'id' => id.to_s,
      'term' => name,
      'data' => {

      }
    }
    Soulmate::Loader.new("brand").add(nugget)
  end
end
