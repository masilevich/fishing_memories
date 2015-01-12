FactoryGirl.define do
  factory :user do
    sequence(:username)  { |n| "person_#{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :confirmed_user do
      confirmed_at Time.now
    end

    factory :admin, parent: :confirmed_user do
      role "admin"
    end

  end

  factory :memory do
    description { Faker::Lorem.sentence }
    occured_at Time.now
    user
  end

  factory :tackle do
    name { Faker::Lorem.sentence }
    user
  end
end