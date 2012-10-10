require 'spec_helper'

describe Item do
  it "should require gender" do
    FactoryGirl.build(:item, :gender => nil).should be_invalid
  end

  it "should require size" do
    FactoryGirl.build(:item, :size => nil).should be_invalid
  end

  it "should require type" do
    FactoryGirl.build(:item, :item_type => nil).should be_invalid
  end

  it "should require an existing type" do
    FactoryGirl.build(:item, :item_type => "foobar").should be_invalid
  end

  it "should require brand" do
    FactoryGirl.build(:item, :brand => nil).should be_invalid
  end

  it "should require new_with_tags" do
    FactoryGirl.build(:item, :new_with_tags => nil).should be_invalid
  end

  it "should require user" do
    FactoryGirl.build(:item, :user_id => nil).should be_invalid
  end

  describe "all_sizes method" do
    it "should return a non-empty array of sizes" do
      Item.all_sizes.should be_a(Array)
      Item.all_sizes.should_not be_empty
    end
  end
end
