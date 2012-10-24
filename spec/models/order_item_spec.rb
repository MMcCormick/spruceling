# == Schema Information
#
# Table name: order_items
#
#  box_id   :integer
#  id       :integer          not null, primary key
#  order_id :integer
#

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

  describe "empty_box_delivered" do
    it "should email the sender" do
      @order_item = FactoryGirl.create(:order_item)
      @order_item.empty_box_delivered
      ActionMailer::Base.deliveries.should_not be_empty
      ActionMailer::Base.deliveries.map{ |d| d.to }.should include [@order_item.box.user.email]
    end
  end
end
