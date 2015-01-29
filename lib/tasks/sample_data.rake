namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_memories 
  end

  task populate_memories: :environment do
    make_memories 
  end
end

def make_users
  @admin = User.create!(username: "jorik",
    email: "l.masilevich@gmail.com",
    password: "foobar",
    password_confirmation: "foobar",
    confirmed_at: "21.04.2014" 
    )
  #@admin.admin!
  10.times do |n|
    User.create!(
      username: "#{Faker::Name.first_name}#{n}",
      email: Faker::Internet.safe_email,
      password: "password",
      password_confirmation: "password",
      confirmed_at: "21.04.2014")
  end

end

def make_memories
  user = User.first
  30.times do
    user.memories.create(
      description: Faker::Lorem.sentence,
      occured_at: Time.now)
  end
end



