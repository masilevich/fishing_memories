namespace :db do
  desc "Fill database with sample data"

  task make_jorik_admin: :environment do
    @jorik = User.find_by username: "jorik"
    @jorik.admin!
  end

end