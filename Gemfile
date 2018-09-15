source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.4'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes

gem 'coffee-rails', '~> 4.2'
# gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'


gem 'slim-rails'
gem 'devise'
gem 'jquery-rails'
# gem 'jquery-turbolinks'
gem 'carrierwave'
gem 'remotipart'
gem 'cocoon'
gem 'bootstrap', '~> 4.0.0'
gem 'skim'
gem 'gon'
gem 'responders', '~> 2.0'
gem 'omniauth'
gem 'omniauth-vkontakte'
gem 'omniauth-github'
gem 'cancancan'
gem 'doorkeeper', '4.2.6'
gem 'active_model_serializers', '~> 0.9.3'
gem 'oj'
gem 'oj_mimic_json'
gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', require: nil
gem 'sidetiq'
gem 'whenever', require: false
gem 'mysql2'
gem 'thinking-sphinx', '3.4.2'
gem 'therubyracer', platforms: :ruby

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'rubocop'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'capybara-email'
  gem 'dotenv'
  gem 'dotenv-deployment', require: 'dotenv/deployment'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "letter_opener"
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
end

group :test do
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
  gem 'launchy'
  gem 'json_spec'
  # gem 'poltergeist'
  # gem 'phantomjs', :require => 'phantomjs/poltergeist'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
