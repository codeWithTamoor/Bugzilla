# spec/rails_helper.rb

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Prevent database truncation in production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'pundit/matchers'

# Load support files AFTER Rails is loaded
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

# Ensure test DB is up-to-date
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Fixtures
  config.fixture_paths = [ Rails.root.join('spec/fixtures') ]

  # Include helpers
  config.include FactoryHelpers        # make sure factory_support.rb defines this module
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Pundit::Matchers, type: :policy

  # Use transactional fixtures
  config.use_transactional_fixtures = true

  # Filter Rails gems from backtraces
  config.filter_rails_from_backtrace!
  config.use_transactional_fixtures = true

  # Shoulda Matchers integration
  Shoulda::Matchers.configure do |shoulda_config|
    shoulda_config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
end
