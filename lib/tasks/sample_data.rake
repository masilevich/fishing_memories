namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users  
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
      email: Faker::Internet.email,
      password: "password",
      password_confirmation: "password",
      confirmed_at: "21.04.2014")
  end

end



