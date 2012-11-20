# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "username#{n}"}
    sequence(:name) {|n| "User #{n}"}
    sequence(:email) {|n| "user#{n}@example.com"}
    password 'please'
    password_confirmation 'please'
    # required if the Devise Confirmable module is used
    confirmed_at Time.now
  end
end