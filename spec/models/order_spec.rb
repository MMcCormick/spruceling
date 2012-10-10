require 'spec_helper'

describe Order do

  it "should require user" do
    FactoryGirl.build(:order, :user_id => nil).should be_invalid
  end

end
