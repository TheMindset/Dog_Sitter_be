# frozen_string_literal: true

require 'rails_helper'
require 'pry'

RSpec.describe 'Users query', type: :request do
  it 'returns a list of users' do
    users = create_list(:user, 5)
    dogs = create_list(:dog, 3, user: users.first)

    post '/graphql', params: { query: query }
    json = JSON.parse(response.body)
    data = json['data']['users']

    expect(data.count).to eq(5)

    first_users = users.first

    expect(data.first).to include(
      'id' => first_users.id.to_s,
      'firstName' => first_users.first_name,
      'lastName' => first_users.last_name,
      'shortDesc' => first_users.short_desc,
      'longDesc' => first_users.long_desc
    )

    user_dogs = data.first['dogs']
    first_user_dog = user_dogs.first

    expect(user_dogs.count).to eq(3)
    expect(first_user_dog).to include(
      'id' => dogs.first.id.to_s,
      'name' => dogs.first.name,
      'breed' => dogs.first.breed,
      'weight' => dogs.first.weight,
      'birthdate' => dogs.first.birthdate.to_s,
      'activityLevel' => dogs.first.activity_level,
      'longDesc' => dogs.first.long_desc,
      'shortDesc' => dogs.first. short_desc
    )
  end

  def query
    <<~GQL
      query {
        users {
          id
          firstName
          lastName
          shortDesc
          longDesc
          dogs {
            id
            name
            breed
            weight
            birthdate
            activityLevel
            longDesc
            shortDesc
          }
        }
      }
    GQL
  end
end
