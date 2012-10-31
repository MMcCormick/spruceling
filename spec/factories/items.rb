# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    gender "m"
    size "18 months"
    status "active"
    new_with_tags false
    association :user
    association :item_type
    association :brand
  end
end
