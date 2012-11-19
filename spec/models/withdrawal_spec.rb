# == Schema Information
#
# Table name: withdrawals
#
#  address    :hstore           not null
#  amount     :decimal(8, 2)    not null
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  sent       :boolean          default(FALSE), not null
#  updated_at :datetime         not null
#  user_id    :integer
#

require 'spec_helper'

describe Withdrawal do
  it "should require amount" do
    FactoryGirl.build(:withdrawal, :amount => nil).should be_invalid
  end
  it "should require address" do
    FactoryGirl.build(:withdrawal, :address => nil).should be_invalid
  end
  it "should require sent" do
    FactoryGirl.build(:withdrawal, :sent => nil).should be_invalid
  end
  it "should require user" do
    FactoryGirl.build(:withdrawal, :user => nil).should be_invalid
  end
end
