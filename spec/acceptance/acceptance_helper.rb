require 'rails_helper'
RSpec.configure do |config|
  Capybara.javascript_driver = :poltergeist
  Capybara.server = :puma
  Capybara::Webkit.configure do |config|
    config.allow_url("maxcdn.bootstrapcdn.com")
  end

  config.include AcceptanceMacros, type: :feature

  config.use_transactional_fixtures = false

  config.include SphinxHelpers, type: :feature

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
