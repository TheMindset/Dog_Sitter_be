# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

Dir["./spec/support/**/*.rb"].sort.each { |f| require f }
require 'rspec/rails'
require 'faker'
require 'simplecov'
require 'webmock/rspec'

SimpleCov.start do
  add_filter "/spec/"
end

require 'codecov'

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
                                                                  SimpleCov::Formatter::HTMLFormatter,
                                                                  SimpleCov::Formatter::Codecov,
                                                                ])

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include FactoryBot::Syntax::Methods
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# def stub_json(url, filename)
#   json_response = File.open(filename)
#   stub_request(:get, url).
#     to_return(status: 200, body: json_response)
# end

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.filter_sensitive_data('<GOOGLE_MAPS_API_KEY>') { ENV['GOOGLE_MAPS_API_KEY'] }
end

# Helper method for testing Graphiql response

def user_type_attributes
  "
  id
  firstName
  lastName
  email
  shortDesc
  longDesc
  "
end

def dog_type_attributes
  "
  id
  name
  breed
  weight
  birthdate
  activityLevel
  longDesc
  shortDesc
  "
end

def location_type_attributes
  "
  id
  state
  city
  zipCode
  streetAddress
  "
end

def current_user_type_attributes
  user_type_attributes
end

def compare_gql_and_db_users(first_gql_user, first_db_user)
  expect(first_gql_user).to include(
    'id' => first_db_user.id.to_s,
    'firstName' => first_db_user.first_name,
    'lastName' => first_db_user.last_name,
    'shortDesc' => first_db_user.short_desc,
    'longDesc' => first_db_user.long_desc
  )
end

def compare_gql_and_db_dogs(first_gql_dog, first_db_dog)
  expect(first_gql_dog).to include(
    'id' => first_db_dog.id.to_s,
    'name' => first_db_dog.name,
    'breed' => first_db_dog.breed,
    'weight' => first_db_dog.weight,
    'birthdate' => first_db_dog.birthdate.to_s,
    'activityLevel' => first_db_dog.activity_level,
    'longDesc' => first_db_dog.long_desc,
    'shortDesc' => first_db_dog.short_desc
  )
end

def compare_gql_and_db_location(first_gql_location, first_db_location)
  expect(first_gql_location).to include(
    'id' => first_db_location.id.to_s,
    'state' => first_db_location.state,
    'city' => first_db_location.city,
    'zipCode' => first_db_location.zip_code,
    'streetAddress' => first_db_location.street_address,
  )
end
