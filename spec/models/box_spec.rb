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

  describe "add_item" do
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

    it "should record the item_type when an item is added" do
      @box.add_item(@item)
      @box.item_type_ids.should include(@item.item_type_id)
    end
  end

  describe "remove_item" do
    before(:each) do
      @box.add_item(@item)
    end

    describe "when the item's been added" do
      it "should remove the item if it's there" do
        @box.remove_item(@item)
        @box.items.should_not include(@item)
      end

      it "should remove the item_type if there are no more items of that type" do
        @box.remove_item(@item)
        @box.item_type_ids.should_not include(@item.item_type_id)
      end

      it "should not remove the item_type if there are still items of that type" do
        @box.add_item(FactoryGirl.create(:item, :item_type_id => @item.item_type_id))
        @box.remove_item(@item)
        @box.item_type_ids.should include(@item.item_type_id)
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
      Box.by_filter.should eq [@box, @box2]
    end

    it "should return a box that matches the arguments" do
      Box.by_filter({:gender => "m"}).should include @box2
    end

    it "should not return a box that does not match the arguments" do
      Box.by_filter({:gender => "f"}).should_not include @box2
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
end
