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

    factory :memory_with_ponds_and_tackles do
      ignore do
        tackles_count 2
        ponds_count 2
      end
      after(:create) do |memory, evaluator|
        create_list(:tackle, evaluator.tackles_count, memories: [memory])
        create_list(:pond, evaluator.ponds_count, memories: [memory])
      end
    end
  end

  factory :tackle do
    name { Faker::Lorem.sentence }
    user
  end

  factory :tackle_set do
    name { Faker::Lorem.sentence }
    user

    factory :tackle_set_with_tackles do
      ignore do
        tackles_count 2
      end
      after(:create) do |tackle_set, evaluator|
        create_list(:tackle, evaluator.tackles_count, tackle_sets: [tackle_set])
      end
    end
  end

  factory :pond do
    name { Faker::Lorem.sentence }
    user
  end
end