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

require 'spec_helper'

describe Photo do
  pending "add some examples to (or delete) #{__FILE__}"
end
