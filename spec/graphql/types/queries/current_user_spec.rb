# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CurrentUser query', type: :request do
  # it 'returns the current user based on the token in the params' do
  #   VCR.use_cassette('current_user_query_and_location_create') do
  #     user = create(:user)
  #     dogs = create_list(:dog, 2, user: user)

  #     location = Location.create!(
  #       user: user,
  #       street_address: '52 Rue de la Verrerie',
  #       zip_code: '75003',
  #       city: 'Paris',
  #       state: 'France'
  #     )

  #     params = {
  #       query: query,
  #       google_token: user.google_token
  #     }

  #     post '/graphql', params: params

  #     json = JSON.parse(response.body)
  #     binding.pry
  #     data = json['data']['currentUser']

  #     first_gql_user = data
  #     compare_gql_and_db_users(first_gql_user, user)

  #     first_gql_dog = data['dogs'].first
  #     first_db_dog = dogs.first
  #     compare_gql_and_db_dogs(first_gql_dog, first_db_dog)

  #     first_gql_location = data['location']
  #     compare_gql_and_db_location(first_gql_location, location)
  #   end
  # end

  # def query
  #   <<~GQL
  #     query {
  #       currentUser {
  #         #{user_type_attributes}
  #         dogs {
  #           #{dog_type_attributes}
  #         }
  #         location {
  #           #{location_type_attributes}
  #         }
  #       }
  #     }
  #   GQL
  # end
end
