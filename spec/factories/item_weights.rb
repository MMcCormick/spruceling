# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item_weight do
    name "Pants"
    weights {{"12 months" => 2.0, "18 months" => 3.2, "24 months" => 3.6}}
  end
end
