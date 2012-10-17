require 'spec_helper'

describe ItemType do
  it "should require name" do
    FactoryGirl.build(:item_type, :name => nil).should be_invalid
  end

  it "should require category" do
    FactoryGirl.build(:item_type, :category => nil).should be_invalid
  end

  it "should require an item weight" do
    FactoryGirl.build(:item_type, :item_weight => nil).should be_invalid
  end

  describe "all_types method" do
    before(:each) do
      FactoryGirl.create(:item_type)
    end

    it "should return a non-empty hash" do
      ItemType.all_types.should be_a(Hash)
      ItemType.all_types.should_not be_empty
    end

    it "should have a Pants category which holds a non-empty array" do
      ItemType.all_types["Pants"].should be_a(Array)
    end
  end
end
