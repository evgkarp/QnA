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
# gem 'therubyracer', platforms: :ruby

gem 'coffee-rails', '~> 4.2'
# gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

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

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'rubocop'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'capybara-email'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "letter_opener"
end

group :test do
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
  gem 'launchy'
  # gem 'poltergeist'
  # gem 'phantomjs', :require => 'phantomjs/poltergeist'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
