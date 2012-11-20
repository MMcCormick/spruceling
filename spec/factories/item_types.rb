# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item_type do
    name "Capris"
    short_name "Capris"
    category "Pants"
    association :item_weight
  end
end
