# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :box do
    gender "m"
    size "18 months"
    seller_price 30.00
    association :user
  end
end
