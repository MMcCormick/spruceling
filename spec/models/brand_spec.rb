# == Schema Information
#
# Table name: brands
#
#  created_at :datetime         not null
#  has_image  :boolean
#  id         :integer          not null, primary key
#  name       :string(255)
#  photo      :string(255)
#  slug       :string(255)
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Brand do
  it "should require that name be unique" do
    FactoryGirl.create(:brand, :name => "Foobar")
    FactoryGirl.build(:brand, :name => "Foobar").should be_invalid
  end
end
