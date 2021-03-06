# == Schema Information
#
# Table name: carts
#
#  id      :integer          not null, primary key
#  user_id :integer
#

require 'spec_helper'

describe Cart do

  before (:each) do
    @user = FactoryGirl.create(:user)
  end

  it "should require user" do
    FactoryGirl.build(:cart, :user_id => nil).should be_invalid
  end

  describe "adding a box" do

    before(:each) do
      @cart = FactoryGirl.build(:cart)
      @box = FactoryGirl.create(:box)
    end

    describe "with valid params" do

      it "should add the box to the boxes parameter" do
        @cart.add_box(@box.id)
        @cart.boxes.should include(@box)
      end

      it "should return true" do
        @cart.add_box(@box.id).should == true
      end

    end

    describe "with invalid params" do

      it "should return false" do
        @cart.add_box('foo').should == false
      end

    end

    it "should not add a duplicate box" do
      @cart.add_box(@box.id)
      @cart.add_box(@box.id)
      @cart.boxes.length.should eq(1)
    end

    it "should not allow a user to add their own box" do
      @box.user = @user
      @box.save
      @cart.user = @user
      @cart.add_box(@box.id).should eq(false)
    end

  end

  describe "removing a box" do

    before(:each) do
      @cart = FactoryGirl.build(:cart)
      @box = FactoryGirl.create(:box)
    end

    describe "with valid params" do

      it "should remove the box from the boxes parameter" do
        @cart.remove_box(@box.id)
        @cart.boxes.should_not include(@box)
      end

      it "should return true" do
        @cart.remove_box(@box.id).should == true
      end

    end

    describe "with invalid params" do

      it "should return false" do
        @cart.remove_box('foo').should == false
      end

    end

  end

  describe "#price_total" do
    before(:each) do
      @box1 = FactoryGirl.create(:box, :seller_price => 30.00)
      @cart = FactoryGirl.create(:cart)
      @cart.add_box(@box1)
    end

    it "should return the total of the box prices minus the user's balance" do
      @box2 = FactoryGirl.create(:box, :seller_price => 20.50)
      @cart.add_box(@box2)
      @cart.user.balance = 10.25
      @cart.user.save
      @cart.price_total.should == (@box1.price_total + @box2.price_total - @cart.user.balance)
    end

    it "should return 0 when (box costs - user balance) < $.50" do
      @cart.user.balance = @box1.price_total - 0.49
      @cart.user.save
      @cart.price_total.should == 0.00
    end

    it "should equal #boxes_total if the user has $0 in their account" do
      @cart.user.balance = 0.0
      @cart.user.save
      @cart.price_total.should == @cart.boxes_total
    end
  end

  describe "#boxes_total" do
    it "should return the total of the box prices regardless of user balance" do
      @box1 = FactoryGirl.create(:box, :seller_price => 30.00)
      @box2 = FactoryGirl.create(:box, :seller_price => 20.50)
      @cart = FactoryGirl.create(:cart)
      @cart.add_box(@box1)
      @cart.add_box(@box2)
      @cart.user.balance = 10.25
      @cart.user.save
      @cart.boxes_total.should == (@box1.price_total + @box2.price_total)
    end
  end

end
