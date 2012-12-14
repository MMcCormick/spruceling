require 'spec_helper'

describe Charity do

  describe "#credit_account" do
    before(:each) do
      @charity = FactoryGirl.create(:charity, :balance => 50.00)
    end

    it "should add the amount to the user's balance" do
      @charity.credit_account(24.50)
      @charity.balance.should == 74.50
    end

    it "should return true for any positive number" do
      @charity.credit_account(15.75).should == true
    end

    it "should return false for anything <= 0" do
      @charity.credit_account(0).should == false
      @charity.credit_account(-1).should == false
      @charity.balance.should == 50.00
    end
  end
end
