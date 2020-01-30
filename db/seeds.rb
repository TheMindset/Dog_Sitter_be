# frozen_string_literal: true

require 'faker'
ActionMailer::Base.perform_deliveries = false

sleep(1)
puts "Destroying previous records"
User.destroy_all
Dog.destroy_all
Location.destroy_all

sleep(1)
puts "Resetting sequence"
ActiveRecord::Base.connection.reset_pk_sequence!('users')
ActiveRecord::Base.connection.reset_pk_sequence!('dogs')
ActiveRecord::Base.connection.reset_pk_sequence!('locations')

10.times do
  User.create!(
    first_name: Faker::Name.unique.first_name,
    last_name: Faker::Name.unique.last_name,
    email: Faker::Internet.unique.email,
    long_desc: Faker::Lorem.paragraph_by_chars(number: 256, supplemental: false),
    short_desc: Faker::ChuckNorris.fact,
    google_token: Faker::Alphanumeric.alpha(number: 20)
  )
end

p 'Users are created'

20.times do
  Dog.create!(
    name: Faker::Artist.unique.name,
    birthdate: rand(12 * 10).months.ago.to_date,
    activity_level: rand(3),
    breed: Faker::Creature::Dog.breed,
    long_desc: Faker::Lorem.paragraph_by_chars(number: 256, supplemental: false),
    short_desc: Faker::ChuckNorris.fact,
    weight: rand(30),
    user: User.all.sample,
  )
end

p 'Dogs are created'

10.times do
  Location.create!(
    city: Faker::Address.city,
    lat: Faker::Address.latitude,
    long: Faker::Address.longitude,
    state: Faker::Address.state,
    street_address: Faker::Address.street_address,
    zip_code: Faker::Address.zip_code,
    user: User.all.sample
  )
end

p 'Locations are created'
