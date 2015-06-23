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

    factory :memory_with_attributes do
      ignore do
        tackles_count 2
        ponds_count 2
        places_count 2
      end
      after(:create) do |memory, evaluator|
        create_list(:tackle, evaluator.tackles_count, memories: [memory])
        create_list(:pond, evaluator.ponds_count, memories: [memory])
        create_list(:place, evaluator.places_count, memories: [memory])
      end
    end
  end

  factory :note do
    name { Faker::Lorem.sentence }
    text { Faker::Lorem.sentence }
    user
  end

  factory :tackle do
    name { Faker::Lorem.sentence }
    user
    factory :tackle_with_brand do
      association :brand, factory: :brand
    end
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

  factory :lure do
    name { Faker::Lorem.sentence }
    user

    factory :lure_with_brand do
      association :brand, factory: :brand
    end
  end

  factory :brand do
    name { Faker::Lorem.sentence }
    user
  end

  factory :pond do
    name { Faker::Lorem.sentence }
    user

    factory :pond_with_places do
      ignore do
        places_count 2
      end
      after(:create) do |pond, evaluator|
        create_list(:place, evaluator.places_count, pond: pond)
      end
    end

    factory :pond_with_map do
      association :map, factory: :map
    end
  end

  factory :place do
    name { Faker::Lorem.sentence }
    user

    factory :place_with_pond do
      association :pond, factory: :pond
    end

    factory :place_with_map do
      association :map, factory: :map
    end
  end

  factory :map do
  end

  factory :category do
    sequence(:name) { |n| "Категория #{n}" }
    user
  end

  factory :pond_category do
    sequence(:name) { |n| "Вид водоема #{n}" }
    user
  end

  factory :tackle_category do
    sequence(:name) { |n| "Вид снасти #{n}" }
    user
  end

  factory :tackle_set_category do
    sequence(:name) { |n| "Вид комплекта #{n}" }
    user
  end

  factory :lure_category do
    sequence(:name) { |n| "Вид приманки #{n}" }
    user
  end
end