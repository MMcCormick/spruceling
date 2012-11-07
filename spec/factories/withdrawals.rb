# Read about factories at https://github.com/thoughtbot/factory_girl

# Can't get the stupid address hstore to work
FactoryGirl.define do
  factory :withdrawal do
    amount "9.99"
    address ""
    association :user
  end
end
