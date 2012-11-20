# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    price_total 60.00
    boxes_total 80.00
    association :user
  end
end