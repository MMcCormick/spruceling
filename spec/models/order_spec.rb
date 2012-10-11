require 'spec_helper'

describe Order do

  before (:each) do
    @user = FactoryGirl.create(:user)
  end

  it "should require user" do
    FactoryGirl.build(:order, :user_id => nil).should be_invalid
  end

  it "should require at least one order_item" do
    order = FactoryGirl.build(:order)
    order.order_items = nil
    order.should be_invalid
  end

  describe "#process" do
    let (:stripe_customer) do
      stub_model Stripe::Customer, :id => 'foo', :card => '123'
    end

    before (:each) do
      @box = FactoryGirl.create(:box)
      @user.cart.add_box(@box)
    end

    it "should return an order" do
      Order.process(@user).should be_an_instance_of Order
    end

    context "with an empty cart" do
      before (:each) do
        @user.cart = nil
      end

      it "should add a user error" do
        order = Order.process(@user)
        order.errors.should have_key :user
      end
    end

    context "with no payment information" do
      it "should add a user error" do
        order = Order.process(@user)
        order.errors.should have_key :user
      end
    end

    context "with valid params" do
      it "should call #add_box for each box in cart" do
        @user.should_receive(:stripe).and_return(stripe_customer)
        Order.any_instance.should_receive(:add_box).with(@box)
        Order.process(@user)
      end
    end
  end

  describe "#add_box" do
    before (:each) do
      @order = FactoryGirl.build(:order)
      @box = FactoryGirl.build(:box)
    end

    it "should add an order_item" do
      @order.add_box(@box)
      @order.should have_at_least(1).order_items
    end

    it "should add an order_item with this box" do
      @order.add_box(@box)
      @order.order_items.where(:box_id => @box.id).should exist
    end
  end

end
