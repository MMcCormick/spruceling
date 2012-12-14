# == Schema Information
#
# Table name: items
#
#  box_id        :integer
#  brand_id      :integer
#  gender        :string(255)
#  id            :integer          not null, primary key
#  item_type_id  :integer
#  new_with_tags :boolean
#  photo         :string(255)
#  price         :decimal(8, 2)
#  size          :string(255)
#  status        :string(255)      default("active")
#  user_id       :integer
#

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
    FactoryGirl.build(:item, :item_type => nil).should be_invalid
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

  describe "#all_sizes" do
    it "should return a non-empty array of sizes" do
      Item.all_sizes.should be_a(Array)
      Item.all_sizes.should_not be_empty
    end
  end

  describe "#weight" do
    it "should return a float" do
      item = FactoryGirl.create(:item)

      item.weight.should be_a Float
    end
  end

  describe "#gender_noun" do
    let(:item) {FactoryGirl.create(:item)}
    it "m should return Boys" do
      item.gender = 'm'
      item.gender_noun.should eq('Boys')
    end
    it "f should return Girls" do
      item.gender = 'f'
      item.gender_noun.should eq('Girls')
    end
    it "u should return Unisex" do
      item.gender = 'u'
      item.gender_noun.should eq('Unisex')
    end
  end

  describe "#type_singular" do
    it "should return 'Pair of ___' for pants" do
      type = FactoryGirl.create(:item_type, :name => "Capris", :short_name => "Capris", :category => "Pants")
      item = FactoryGirl.create(:item, :item_type => type)
      item.type_singular.should == "Pair of Capris"
    end
    it "should return 'Pair of ___' for shorts" do
      type = FactoryGirl.create(:item_type, :name => "Khaki / Cotton Shorts", :short_name => "Khaki / Cotton", :category => "Shorts")
      item = FactoryGirl.create(:item, :item_type => type)
      item.type_singular.should == "Pair of Khaki / Cotton Shorts"
    end
    it "should return the singular version of each in the case of 'Coats / Warm Jackets'" do
      type = FactoryGirl.create(:item_type, :name => "Coats / Warm Jackets", :short_name => "Coats / Warm Jackets", :category => "Jackets")
      item = FactoryGirl.create(:item, :item_type => type)
      item.type_singular.should == "Coat / Warm Jacket"
    end
    it "should return the singular version otherwise" do
      type = FactoryGirl.create(:item_type, :name => "Long-sleeve Polos", :short_name => "Polos", :category => "Long-sleeve")
      item = FactoryGirl.create(:item, :item_type => type)
      item.type_singular.should == "Long-sleeve Polo"
    end
  end
end
