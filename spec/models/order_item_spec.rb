require 'spec_helper'

describe OrderItem do

  before (:each) do
    @user = FactoryGirl.create(:user)
  end

  it "should require a box" do
    order_item = FactoryGirl.build(:order_item)
    order_item.box = nil
    order_item.should be_invalid
  end

end
