require 'pundit/matchers'
# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'


ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'

# Ensures that the test database schema matches the current schema file.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

#  Single, clean RSpec configuration block
RSpec.configure do |config|
  # Fixtures
  config.fixture_paths = [Rails.root.join('spec/fixtures')]
  config.include Pundit::Matchers, type: :policy
  # Use transactional fixtures
  config.use_transactional_fixtures = true

  # Filter Rails gems in backtraces
  config.filter_rails_from_backtrace!

  # Include FactoryBot syntax methods (`create`, `build`, etc.)
  # config.include Pundit::Matchers
  config.include FactoryBot::Syntax::Methods

  # Integrate Shoulda Matchers
  Shoulda::Matchers.configure do |shoulda_config|
    shoulda_config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

  

  
end
