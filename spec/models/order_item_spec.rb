# == Schema Information
#
# Table name: order_items
#
#  box_id   :integer
#  id       :integer          not null, primary key
#  order_id :integer
#  paid     :boolean
#

require 'spec_helper'

describe OrderItem do

  before (:each) do
    @user = FactoryGirl.create(:user)
    @order_item = FactoryGirl.create(:order_item)
  end

  it "should require a box" do
    order_item = FactoryGirl.build(:order_item)
    order_item.box = nil
    order_item.should be_invalid
  end

  describe "empty_box_delivered" do
    it "should email the sender" do
      @order_item.empty_box_delivered
      ActionMailer::Base.deliveries.should_not be_empty
      ActionMailer::Base.deliveries.map{ |d| d.to }.should include [@order_item.box.user.email]
    end
  end

  describe "full_box_shipped" do
    it "should email the buyer" do
      @order_item.full_box_shipped
      ActionMailer::Base.deliveries.should_not be_empty
      ActionMailer::Base.deliveries.map{ |d| d.to }.should include [@order_item.order.user.email]
    end

    it "should call User#credit_account with the correct user" do
      @order_item.box.user.should_receive(:credit_account)
      @order_item.full_box_shipped
    end

    context "when User#credit_account is successful" do
      before(:each) do
        @order_item.box.user.should_receive(:credit_account).once.and_return(true)
      end
      it "should set the paid variable to true" do
        @order_item.paid.should == false
        @order_item.full_box_shipped
        @order_item.paid.should == true
      end

      it "should not credit the user's account more than once" do
        @order_item.full_box_shipped
        @order_item.full_box_shipped
      end

      it "should save the user" do
        @order_item.box.user.should_receive(:save)
        @order_item.full_box_shipped
      end

      it "should save the order item" do
        @order_item.should_receive(:save)
        @order_item.full_box_shipped
      end
    end

    context "when User#credit_account is successful" do
      it "should not set the paid variable to true" do
        @order_item.box.user.should_receive(:credit_account).once.and_return(false)
        @order_item.paid.should == false
        @order_item.full_box_shipped
        @order_item.paid.should == false
      end
    end
  end

  describe "full_box_delivered" do
    it "should email the buyer" do
      @order_item.full_box_delivered
      ActionMailer::Base.deliveries.should_not be_empty
      ActionMailer::Base.deliveries.map{ |d| d.to }.should include [@order_item.order.user.email]
    end
  end
end
