require 'spec_helper'

describe Box do
  it "should require gender" do
    FactoryGirl.build(:box, :gender => nil).should be_invalid
  end

  it "should require size" do
    FactoryGirl.build(:box, :size => nil).should be_invalid
  end

  describe "add_item" do
    before(:each) do
      @item = FactoryGirl.create(:item)
      @box = FactoryGirl.create(:box, :gender => @item.gender, :size => @item.size)
    end

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
end
