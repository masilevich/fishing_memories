source 'https://rubygems.org'

ruby '2.2.0'

gem 'rails', '4.1.4'
gem 'sass-rails', '~> 4.0.2'
gem 'coffee-rails', '4.0.1'
gem 'jquery-rails', '3.0.4'
gem 'jquery-ui-rails'
gem 'bourbon'
gem 'turbolinks'
gem 'cancancan'
gem 'devise'
gem 'faker'
gem 'formtastic', '~> 3.0'
gem 'kaminari'
gem 'select2-rails'
gem 'ckeditor'
gem 'ransack'

group :production do
  gem 'pg', '0.15.1'

end

group :development, :test do
  gem 'sqlite3'
  gem "rspec-rails", '~> 2.14.0.rc1'
  gem 'byebug'
end

group :test do
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.2.0'
  gem 'factory_girl_rails', '4.2.1'
end

group :development do
  # Debugging
  gem 'better_errors'      # Web UI to debug exceptions. Go to /__better_errors to access the latest one
  gem 'binding_of_caller'  # Retrieve the binding of a method's caller in MRI Ruby >= 1.9.2
  gem 'rack-mini-profiler'
  gem 'bullet'
end