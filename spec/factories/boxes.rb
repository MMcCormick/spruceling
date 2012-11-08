# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :box do |box|
    box.gender {"m"}
    box.size {"18 months"}
    box.seller_price {30.00}
    box.association :user
  end
end
