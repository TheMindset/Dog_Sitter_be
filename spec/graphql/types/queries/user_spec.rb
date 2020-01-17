# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User query', type: :request do
  it 'return user by ID' do
    user = create(:user)
    dogs = create_list(:dog, 2, user: user)

    post '/graphql', params: { query: query(id: user.id) }

    json = JSON.parse(response.body)
    data = json['data']['user']

    expect(data).to include(
      'id' => user.id.to_s,
      'firstName' => user.first_name,
      'lastName' => user.last_name,
      'shortDesc' => user.short_desc,
      'longDesc' => user.long_desc
    )

    first_dog = data['dogs'].first

    expect(data['dogs'].count).to eq(2)
    expect(first_dog).to include(
      'id' => dogs.first.id.to_s,
      'name' => dogs.first.name,
      'breed' => dogs.first.breed,
      'weight' => dogs.first.weight,
      'birthdate' => dogs.first.birthdate.to_s,
      'activityLevel' => dogs.first.activity_level,
      'longDesc' => dogs.first.long_desc,
      'shortDesc' => dogs.first.short_desc
    )
  end

  def query(id:)
    <<~GQL
      query {
        user(id: #{id}) {
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
