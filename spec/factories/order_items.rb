# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order_item do
    association :box
    association :order
  end
end