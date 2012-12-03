# == Schema Information
#
# Table name: brands
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  name       :string(255)
#  photo      :string(255)
#  slug       :string(255)
#  updated_at :datetime         not null
#

class Brand < ActiveRecord::Base
  attr_accessible :name

  extend FriendlyId
  friendly_id :name, :use => :slugged

  has_many :items, :inverse_of => :brand

  validates_uniqueness_of :name

  after_create :add_to_soulmate

  def icon_path(color=false, size='small')
    "/images/brands/#{name.parameterize('_').downcase}_place_#{size}_#{color ? 'color' : 'no_color'}.png"
  end

  def add_to_soulmate
    nugget = {
      'id' => id.to_s,
      'term' => name,
      'data' => {

      }
    }
    begin
      Soulmate::Loader.new("brand").add(nugget)
    rescue => e
      #raise "Could not connect to Soulmate"
    end
  end
end
