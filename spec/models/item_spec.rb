require 'spec_helper'

describe Item do
  it "should require gender" do
    FactoryGirl.build(:item, :gender => nil).
        should be_invalid
  end

  it "should require size" do
    FactoryGirl.build(:item, :size => nil).
        should be_invalid
  end

  it "should require type" do
    FactoryGirl.build(:item, :type => nil).
        should be_invalid
  end

  it "should require brand" do
    FactoryGirl.build(:item, :brand => nil).
        should be_invalid
  end

  describe "all_sizes method" do
    it "should return a non-empty array of sizes" do
      Item.all_sizes.should be_a(Array)
      Item.all_sizes.should_not be_empty
    end
  end

  describe "all_types method" do
    it "should return a non-empty array of types" do
      Item.all_types.should be_a(Array)
      Item.all_types.should_not be_empty
    end
  end
end
