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
    content "Lorem ipsum"
    occured_at Time.now
    user
  end
end