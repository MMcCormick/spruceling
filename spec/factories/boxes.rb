# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :box do
    gender "m"
    size "18 months"
    price_total 30.00
    association :user
  end
end
