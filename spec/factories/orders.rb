# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    association :user
    order_items    { [FactoryGirl.build(:order_item), FactoryGirl.build(:order_item)] }
  end
end