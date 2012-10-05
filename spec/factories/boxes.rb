# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :box do
    gender "MyString"
    size "MyString"
    association :user
  end
end
