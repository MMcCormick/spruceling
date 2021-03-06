# == Schema Information
#
# Table name: orders
#
#  boxes_total      :decimal(8, 2)    not null
#  created_at       :datetime
#  id               :integer          not null, primary key
#  price_total      :decimal(8, 2)    not null
#  stripe_charge_id :string(255)
#  updated_at       :datetime
#  user_id          :integer
#

require 'spec_helper'

describe Order do

  let (:stripe_customer) do
    stub_model Stripe::Customer, :id => 'foo', :card => '123'
  end

  let (:stripe_charge) do
    stub_model Stripe::Charge, :id => 'foo'
  end

  before (:each) do
    @user = FactoryGirl.create(:user)
    @box = FactoryGirl.create(:box)
    @box2 = FactoryGirl.create(:box)
  end

  it "should require user" do
    FactoryGirl.build(:order, :user => nil).should be_invalid
  end

  it "should require price_total" do
    FactoryGirl.build(:order, :price_total => nil).should be_invalid
  end

  it "should require price_total to be at least $0.0" do
    FactoryGirl.build(:order, :price_total => -0.5).should be_invalid
  end

  it "should allow price_total to be $0.0" do
    FactoryGirl.build(:order, :price_total => 0.0).should be_valid
  end

  it "should require boxes_total" do
    FactoryGirl.build(:order, :boxes_total => nil).should be_invalid
  end

  it "should require boxes_total to be at least $1" do
    FactoryGirl.build(:order, :boxes_total => 0.5).should be_invalid
  end

  it "should have all the cuts add up to 100%" do
    (Order.spruceling_cut + Order.seller_cut + Order.charity_cut).should == 1
  end

  it "should have a #boxes method if there have been boxes added" do
    @order = FactoryGirl.create(:order)
    @order.add_box(@box)
    @order.save
    @order.boxes.should include @box
  end

  describe "#generate" do
    before (:each) do
      @user.cart.add_box(@box)
    end

    it "should return an order" do
      Order.generate(@user).should be_an_instance_of Order
    end

    context "with an empty cart" do
      before (:each) do
        @user.cart = nil
      end

      it "should add an error" do
        order = Order.generate(@user)
        order.errors.should_not be_empty
      end
    end

    context "with no payment information" do
      it "should add an error" do
        order = Order.generate(@user)
        order.errors.should_not be_empty
      end
    end

    context "with valid params" do
      before (:each) do
        @user.should_receive(:stripe).and_return(stripe_customer)
      end

      it "should call #add_box for each box in cart" do
        Order.any_instance.should_receive(:add_box).with(@box)
        Order.generate(@user)
      end

      it "should return a valid order" do
        Order.generate(@user).should be_valid
      end

      it "should set the order's price total equal to the cart's price total" do
        order = Order.generate(@user)
        order.price_total.should == @user.cart.price_total
      end

      it "should set the order's boxes total equal to the cart's boxes total" do
        order = Order.generate(@user)
        order.boxes_total.should == @user.cart.boxes_total
      end
    end
  end

  describe "#process" do
    context "with valid params" do
      before (:each) do
        @user.should_receive(:stripe).and_return(stripe_customer)
      end

      it "should empty the users cart" do
        @user.cart.add_box(@box)
        @user.cart.boxes.length.should eq(1)
        @order = Order.generate(@user)
        @order.process
        @user.reload.cart.boxes.length.should eq(0)
      end

      it "should change the boxes status to sold" do
        @user.cart.add_box(@box)
        @order = Order.generate(@user)
        @order.process
        @box.reload.status.should eq('sold')
      end

      it "should change the boxes items status to sold" do
        @user.cart.add_box(@box)
        @order = Order.generate(@user)
        @order.process
        @box.items.each do |i|
          i.status.should eq('sold')
        end
      end
    end
  end

  describe "#add_box" do
    before (:each) do
      @order = FactoryGirl.create(:order)
    end

    it "should add an order_item" do
      @item = @order.add_box(@box)
      @order.save
      @item.save
      @order.should have_at_least(1).order_items
    end

    it "should add an order_item with this box" do
      @item = @order.add_box(@box)
      @item.save
      @order.order_items.where(:box_id => @box.id).should exist
    end
  end

  describe "#charge" do
    before (:each) do
      @order = FactoryGirl.create(:order)
      @order.user = @user
      @order.save
      @box = FactoryGirl.create(:box)
      @order.add_box(@box)
      @user.stub(:stripe).and_return stripe_customer
    end

    it "should assign a stripe_charge_id" do
      Stripe::Charge.should_receive(:create).and_return(stripe_charge)
      @order.charge
      @order.stripe_charge_id.should_not be_nil
    end

    it "should not charge if it has already been charged" do
      Stripe::Charge.stub(:create).and_return(stripe_charge)
      @order.stripe_charge_id = 'foo'
      @order.charge.should eq(false)
    end
  end

  describe "#send_confirmations" do
    let (:stripe_charge) do
      stub_model Stripe::Charge, :card => {:type => "Visa", :last4 => "1234"}
    end
    before(:each) do
      @order = FactoryGirl.create(:order)
      Order.any_instance.stub(:stripe_charge).and_return(stripe_charge)
    end

    it "should email a receipt to the user who ordered" do
      @order.send_confirmations
      ActionMailer::Base.deliveries.should_not be_empty
      ActionMailer::Base.deliveries.map{ |d| d.to }.should include [@order.user.email]
    end

    it "should email each sender" do
      @order.add_box(FactoryGirl.create(:box))
      @order.add_box(FactoryGirl.create(:box))
      @order.save
      @order.send_confirmations
      @order.boxes.map{|box| box.user}.uniq.each do |user|
        ActionMailer::Base.deliveries.map{ |d| d.to }.should include [user.email]
      end
    end
  end

end
