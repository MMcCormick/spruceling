# == Schema Information
#
# Table name: order_items
#
#  box_id   :integer
#  id       :integer          not null, primary key
#  order_id :integer
#  paid     :boolean          default(FALSE)
#  status   :string(255)      default("active")
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

  it "should require a status" do
    order_item = FactoryGirl.build(:order_item, :status => nil).should be_invalid
  end

  describe "empty_box_delivered" do
    it "should email the sender" do
      @order_item.empty_box_delivered
      ActionMailer::Base.deliveries.should_not be_empty
      ActionMailer::Base.deliveries.map{ |d| d.to }.should include [@order_item.box.user.email]
    end

    it "should set the status to 'empty_box_delivered' and save" do
      @order_item.should_receive :save
      @order_item.empty_box_delivered
      @order_item.status.should == 'empty_box_delivered'
    end
  end

  describe "full_box_shipped" do
    it "should call User#credit_account with the correct user" do
      @order_item.box.user.should_receive(:credit_account)
      @order_item.full_box_shipped
    end

    context "when User#credit_account is successful" do
      before(:each) do
        @order_item.box.user.should_receive(:credit_account).once.and_return(true)
      end

      it "should email the buyer" do
        @order_item.full_box_shipped
        ActionMailer::Base.deliveries.should_not be_empty
        ActionMailer::Base.deliveries.map{ |d| d.to }.should include [@order_item.order.user.email]
      end

      it "should set the paid variable to true" do
        @order_item.paid.should == false
        @order_item.full_box_shipped
        @order_item.paid.should == true
      end

      it "should not credit the user's account more than once (and should raise an error)" do
        expect {
          @order_item.full_box_shipped
          @order_item.full_box_shipped
        }.to raise_error
      end

      it "should set the status to 'full_box_shipped'" do
        @order_item.full_box_shipped
        @order_item.status.should == 'full_box_shipped'
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

    context "when User#credit_account is unsuccessful" do
      before(:each) do
        @order_item.box.user.should_receive(:credit_account).once.and_return(false)
      end

      it "should not set the paid variable to true" do
        @order_item.paid.should == false
        @order_item.full_box_shipped
        @order_item.paid.should == false
      end

      it "should not email the buyer" do
        @order_item.full_box_shipped
        ActionMailer::Base.deliveries.should be_empty
      end
    end
  end

  describe "full_box_delivered" do
    it "should email the buyer" do
      @order_item.full_box_delivered
      ActionMailer::Base.deliveries.should_not be_empty
      ActionMailer::Base.deliveries.map{ |d| d.to }.should include [@order_item.order.user.email]
    end

    it "should set the status to 'full_box_delivered' and save" do
      @order_item.should_receive :save
      @order_item.full_box_delivered
      @order_item.status.should == 'full_box_delivered'
    end
  end
end
