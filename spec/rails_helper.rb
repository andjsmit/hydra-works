require 'spec_helper'
ENV["RAILS_ENV"] ||= 'test'

# require 'factory_girl'
# require 'database_cleaner'
# require 'devise'
require 'engine_cart'
EngineCart.load_application!

require 'rspec/rails'
# require 'capybara/poltergeist'
# Capybara.javascript_driver = :poltergeist
# Capybara.default_wait_time = ENV['TRAVIS'] ? 30 : 15
# require 'capybara/rspec'
# require 'capybara/rails'


# if ENV['COVERAGE'] || ENV['CI']
#   require 'simplecov'
#   require 'coveralls'
# 
#   ENGINE_ROOT = File.expand_path('../..', __FILE__)
#   SimpleCov.formatter = Coveralls::SimpleCov::Formatter if ENV["CI"]
#   SimpleCov.start do
#     add_filter '/spec/'
#   end
# end

require 'hydra/works'

Dir["./spec/support/**/*.rb"].sort.each {|f| require f}

# FactoryGirl.definition_file_paths = [File.expand_path("../factories", __FILE__)]
# FactoryGirl.find_definitions

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.fixture_path = File.expand_path("../fixtures", __FILE__)

  # config.before :each do
  #   if Capybara.current_driver == :rack_test
  #     DatabaseCleaner.strategy = :transaction
  #   else
  #     DatabaseCleaner.strategy = :truncation
  #   end
  #   DatabaseCleaner.start
  # end

  # config.after do
  #   DatabaseCleaner.clean
  # end

  # config.include FactoryGirl::Syntax::Methods
  # config.include Devise::TestHelpers, type: :controller
  # config.include Devise::TestHelpers, type: :view
  # config.include Warden::Test::Helpers, type: :feature
  # config.after(:each, type: :feature) { Warden.test_reset! }
  # config.include Controllers::EngineHelpers, type: :controller
  # config.include Capybara::DSL
  config.infer_spec_type_from_file_location!
  config.deprecation_stream
end

