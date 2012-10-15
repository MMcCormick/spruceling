# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :box do
    gender "m"
    size "18 months"
    association :user
  end
end
