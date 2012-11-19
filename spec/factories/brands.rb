# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :brand do
    sequence(:name) {|n| "Brand #{n}"}
  end
end
