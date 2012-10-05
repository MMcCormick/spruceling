require 'spec_helper'

describe Box do
  it "should require gender" do
    FactoryGirl.build(:box, :gender => nil).
        should be_invalid
  end

  it "should require size" do
    FactoryGirl.build(:box, :size => nil).
        should be_invalid
  end

  describe "add_item" do
    before(:each) do
      @item = FactoryGirl.create(:item)
      @box = FactoryGirl.create(:box)
    end

    it "should add a passed item to the box" do
      @box.add_item(@item)
      @box.items.should include(@item)
    end
  end
end
