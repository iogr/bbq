source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'devise'
gem 'devise-i18n'
gem 'rails-i18n', '~> 6.0.0'

gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
gem 'twitter-bootstrap-rails'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'jquery-rails'
gem 'listen'

gem 'carrierwave'
gem 'rmagick'
gem 'fog-aws'

group :production do
  gem 'pg'
end

group :development, :test do
  gem 'pry-rails'
  gem 'sqlite3', '~> 1.4'
  gem 'byebug'
  gem 'factory_bot_rails'
end

