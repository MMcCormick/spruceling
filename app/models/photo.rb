# == Schema Information
#
# Table name: photos
#
#  created_at     :datetime         not null
#  id             :integer          not null, primary key
#  image          :string(255)
#  imageable_id   :integer
#  imageable_type :integer
#  updated_at     :datetime         not null
#

class Photo < ActiveRecord::Base

  belongs_to :imageable, :polymorphic => true
  attr_accessible :image, :imageable_id, :imageable_type
  mount_uploader :image, ImageUploader

  def image_name
    self['image'].split('/').last
  end

end
