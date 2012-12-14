# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :charity do
    name "Foo"
    balance 20.00
    goal 200.00
    status "active"
  end
end
