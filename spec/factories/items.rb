# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    gender "MyString"
    size "MyString"
    brand "MyString"
    user nil
    box nil
    type ""
  end
end
