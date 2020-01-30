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

# Users
def user_type_attributes
  "
  id
  firstName
  shortDesc
  longDesc
  distance
  "
end

def compare_gql_and_db_users(first_gql_user, first_db_user)
  expect(first_gql_user).to include(
    'id' => first_db_user.id.to_s,
    'firstName' => first_db_user.first_name,
    'shortDesc' => first_db_user.short_desc,
    'longDesc' => first_db_user.long_desc
  )
end

# current_user
def current_user_type_attributes
  user_type_attributes +
    '
    email
    lastName
    '
end

def compare_gql_and_db_current_users(gql_user, db_user)
  expect(gql_user).to include(
    'id' => db_user.id.to_s,
    'firstName' => db_user.first_name,
    'shortDesc' => db_user.short_desc,
    'longDesc' => db_user.long_desc,
    'email' => db_user.email
  )
end

# Dogs
def dog_type_attributes
  "
  id
  name
  breed
  weight
  distance
  birthdate
  activityLevel
  longDesc
  shortDesc
  "
end

def compare_gql_and_db_dogs(gql_dog, db_dog, include_id = true)
  if include_id
    expect(gql_dog).to include(
      'id' => db_dog.id.to_s
    )
  end

  expect(gql_dog).to include(
    'name' => db_dog.name,
    'breed' => db_dog.breed,
    'weight' => db_dog.weight,
    'birthdate' => db_dog.birthdate.to_s,
    'activityLevel' => db_dog.activity_level,
    'longDesc' => db_dog.long_desc,
    'shortDesc' => db_dog.short_desc
  )
end

# Location
def location_type_attributes
  "
  id
  state
  city
  zipCode
  streetAddress
  "
end

def compare_gql_and_db_location(gql_location, db_location, include_id = true)
  if include_id
    expect(gql_location).to include(
      'id' => db_location.id.to_s
    )
  end

  expect(gql_location).to include(
    'state' => db_location.state,
    'city' => db_location.city,
    'zipCode' => db_location.zip_code,
    'streetAddress' => db_location.street_address
  )
end
