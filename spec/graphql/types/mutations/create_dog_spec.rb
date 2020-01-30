# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CreateUser', type: :request do
  it 'user authenticate can create a new dog' do
    user = create(:user)

    new_dog = Dog.new(
      name: 'Luffy',
      activity_level: 2,
      breed: 'Pirate',
      birthdate: '2018-01-23',
      weight: 14,
      long_desc: 'Houloulou ils ont fumé joseppé',
      short_desc: 'Matuidi charo'
    )

    params = {
      google_token: user.google_token,
      query: create_dog_mutation(new_dog)
    }

    post '/graphql', params: params

    json = JSON.parse(response.body)

    gql_dog = json['data']['createDog']['dog']
    compare_gql_and_db_dogs(gql_dog, new_dog, false)
  end

  it 'user unauthorized can dog create a new dog' do
    new_dog = Dog.new(
      name: 'Luffy',
      activity_level: 2,
      breed: 'Pirate',
      birthdate: '2018-01-23',
      weight: 14,
      long_desc: 'Houloulou ils ont fumé joseppé',
      short_desc: 'Matuidi charo'
    )

    params = {
      google_token: nil,
      query: create_dog_mutation(new_dog)
    }

    post '/graphql', params: params

    json = JSON.parse(response.body)

    errors = json['errors'].first['message']
    expect(errors).to eq('Unauthorized - a valid google_token query parameter is required')
  end

  def create_dog_mutation(new_dog)
    "mutation {
      createDog(input: {
        dog: {
          name: \"#{new_dog.name}\",
          activityLevel: #{new_dog.activity_level},
          breed: \"#{new_dog.breed}\",
          birthdate: \"#{new_dog.birthdate}\",
          weight: #{new_dog.weight},
          longDesc: \"#{new_dog.long_desc}\",
          shortDesc: \"#{new_dog.short_desc}\"
        }
      })
      {
        dog {
          #{dog_type_attributes}
        }
      }
    }
    "
  end
end
