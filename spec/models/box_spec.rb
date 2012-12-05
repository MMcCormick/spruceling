# == Schema Information
#
# Table name: boxes
#
#  gender       :string(255)
#  id           :integer          not null, primary key
#  is_featured  :boolean          default(FALSE)
#  notes        :string(255)
#  rating       :decimal(, )
#  review       :string(255)
#  seller_price :decimal(8, 2)
#  size         :string(255)
#  status       :string(255)      default("active")
#  user_id      :integer
#

require 'spec_helper'

describe Box do
  before(:each) do
    @item = FactoryGirl.create(:item)
    @box = FactoryGirl.create(:box, :gender => @item.gender, :size => @item.size)
  end

  it "should require user" do
    FactoryGirl.build(:box, :user_id => nil).should be_invalid
  end
  it "should give the owner permission to manage it" do
    ability = Ability.new(@box.user)
    ability.can?(:manage, @box).should == true
  end
  it "should require gender" do
    FactoryGirl.build(:box, :gender => nil).should be_invalid
  end
  it "should require size" do
    FactoryGirl.build(:box, :size => nil).should be_invalid
  end
  it "should require seller_price if active" do
    FactoryGirl.build(:box, :seller_price => nil, :status => 'active').should be_invalid
  end
  it "should require seller_price to be at least $1" do
    FactoryGirl.build(:box, :seller_price => 0.5, :status => 'active').should be_invalid
  end
  it "should require seller_price to be less than $1000" do
    FactoryGirl.build(:box, :seller_price => 1500, :status => 'active').should be_invalid
  end
  it "should not require the seller_price if not active" do
    FactoryGirl.build(:box, :seller_price => 5, :status => 'inactive').should be_valid
  end
  it "should require seller_price to be a BigDecimal" do
    @box.seller_price.should be_a BigDecimal
  end
  it "should allow rating to be nil" do
    FactoryGirl.build(:box, :rating => nil).should be_valid
  end
  it "should require rating to be between 0 and 5" do
    FactoryGirl.build(:box, :rating => -1.0).should be_invalid
    FactoryGirl.build(:box, :rating => 6.0).should be_invalid
    FactoryGirl.build(:box, :rating => 5.0).should be_valid
  end

  describe "#price_total" do
    it "should be greater than the seller price" do
      @box.price_total.should > @box.seller_price
    end
    it "should return a BigDecimal" do
      @box.price_total.should be_a BigDecimal
    end
  end

  it "should have an #order method if it's been added to an order" do
    @order = FactoryGirl.create(:order)
    @order.add_box(@box)
    @order.save
    @box.order.should eq @order
  end

  describe "#gender_noun" do
    it "m should return Boys" do
      @box.gender = 'm'
      @box.gender_noun.should eq('Boys')
    end
    it "f should return Girls" do
      @box.gender = 'f'
      @box.gender_noun.should eq('Girls')
    end
  end

  describe "#add_item" do
    it "should reject an item which does not match gender / size and return false" do
      @item2 = FactoryGirl.create(:item, :size => "foobar")
      @box.add_item(@item2).should == false
      @box.items.should_not include(@item2)
    end

    it "should reject an item which is already in another box and return false" do
      @box.add_item(@item)
      @box2 = FactoryGirl.create(:box)
      @box2.add_item(@item).should == false
      @box2.items.should_not include(@item)
    end

    it "should accept a valid item and add it to the box" do
      @box.add_item(@item)
      @box.items.should include(@item)
    end
  end

  describe "#remove_item" do
    before(:each) do
      @box.add_item(@item)
    end

    describe "when the item's been added" do
      it "should remove the item if it's there" do
        @box.remove_item(@item)
        @box.items.should_not include(@item)
      end
    end
    it "should do nothing if the item has not been added" do
      @item2 = FactoryGirl.create(:item)
      expect { @box.remove_item(@item2) }.to_not change{@box.items.length}
    end
  end

  describe "#by_filter" do
    before(:each) do
      @box2 = FactoryGirl.create(:box, :gender => "m")
    end

    it "should return all boxes when no arguments are passed" do
      Box.by_filter.should include @box
      Box.by_filter.should include @box2
    end

    it "should return a box that matches the arguments" do
      Box.by_filter({:gender => "m"}).should include @box2
    end

    it "should not return a box that does not match the arguments" do
      Box.by_filter({:gender => "f"}).should_not include @box2
    end
  end

  describe "#item_type_counts" do
    it "should return a hash" do
      @box.item_type_counts.should be_a Hash
    end
    it "should add up to the number of items on the box" do
      sum = @box.item_type_counts.inject{|sum,n| sum + n}
      sum ||= 0
      sum.should eq(@box.items.length)
    end
  end

  describe "#weight" do
    context "when there are items in the box" do
      before(:each) do
        @item2 = FactoryGirl.create(:item)
        @box.add_item(@item)
        @box.add_item(@item2)
      end

      it "should return a float" do
        @box.weight.should be_a Float
      end

      it "should return the sum of the weights contained" do
        @box.weight.should == @item.weight + @item2.weight
      end
    end

    context "when the box is empty" do
      it "should return 0" do
        @box.weight.should == 0
      end
    end
  end

  describe "#recommended_price" do
    it "should return a float"
  end

  describe "#featured" do
    before :each do
      @box2 = FactoryGirl.create(:box, :gender => @item.gender, :size => @item.size, :is_featured => true)
    end
    it "should return featured boxes" do
      Box.featured.should include @box2
    end
    it "should not return non-featured boxes" do
      Box.featured.should_not include @box
    end
  end

  describe "#rating"

  describe "#ordered_by?" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    it "should return true if the passed user ordered the box" do
      @order = FactoryGirl.create(:order, :user => @user)
      @order.add_box(@box)
      @order.save
      @box.ordered_by?(@user).should == true
    end

    it "should return false if the passed user did not order the box" do
      @order = FactoryGirl.create(:order)
      @box.ordered_by?(@user).should == false
    end

    it "should return false if no user is passed" do
      @box.ordered_by?(nil).should == false
    end
  end
end
