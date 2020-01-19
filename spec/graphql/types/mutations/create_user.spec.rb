# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'createUser', type: :request do
  it 'return a successful user creation' do
    first_name = "Marco"
    last_name = "Polo"
    email = "explorer@marco.com"
    short_desc = "I am the best explorer in the world"
    long_desc = "
      Marco Polo was an Italian merchant, explorer, and writer who travelled through Asia along the Silk Road between 1271 and 1295.
      His travels are recorded in The Travels of Marco Polo (also known as Book of the Marvels of the World and Il Milione, c. 1300),
      a book that described to Europeans the then mysterious culture and inner workings of the Eastern world, including the wealth and great
      size of China and its capital Peking, giving their first comprehensive look into China, India, Japan and other Asian cities and countries.
    "

    query = "
    mutation {
      createUser(input: {
        firstName: \"#{first_name}\"
        lastName: \"#{last_name}\"
        email: \"#{email}\"
        shortDesc: \"#{short_desc}\"
        longDesc: \"#{long_desc}\"
      }) {
        user {
          #{user_type_attributes}
        }
      }
    }
    "

    post '/graphql', params: { query: query }
    json = JSON.parse(response.body)

    data = json['data']['createUser']['user']

    expect(data).to have_key("id")

    expect(data).to include(
      'firstName' => first_name,
      'lastName' => last_name,
      'email' => email,
      'shortDesc' => short_desc,
      'longDesc' => long_desc,
    )

    expect(User.count).to eq(1)
  end
end
