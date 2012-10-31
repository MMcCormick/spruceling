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
    it "should return the total of the box prices" do
      @box1 = FactoryGirl.create(:box, :seller_price => 30.00)
      @box2 = FactoryGirl.create(:box, :seller_price => 20.50)
      @cart = FactoryGirl.create(:cart)
      @cart.add_box(@box1)
      @cart.add_box(@box2)
      @cart.price_total.should == (@box1.price_total + @box2.price_total)
    end
  end

end
