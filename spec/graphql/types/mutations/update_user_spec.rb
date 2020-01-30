# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UpdateUser', type: :request do
  before do
    VCR.use_cassette('update_user_mutation_spec/before_each') do
      @current_user = create(:user)

      @current_user_location = Location.create!(
        user: @current_user,
        street_address: '52 Rue de la Verrerie',
        zip_code: '75003',
        city: 'Paris',
        state: 'France'
      )
    end
  end

  describe 'current user requests with valid google token' do
    it 'update his informations' do
      user_update_infos = User.new(
        first_name: 'Pompei',
        last_name: '1er',
        short_desc: 'The last King',
        long_desc: '...'
      )

      params = {
        google_token: @current_user.google_token,
        query: update_user_mutation_spec(user_update_infos)
      }

      post '/graphql', params: params

      json = JSON.parse(response.body)
      data = json['data']['updateUser']

      gql_user = data['currentUser']
      compare_gql_and_db_current_users(gql_user, @current_user.reload)

      gql_location = gql_user['location']
      compare_gql_and_db_location(gql_location, @current_user_location.reload, true)
    end
  end

  describe 'current user requests' do
    it 'update his informations' do
      user_update_infos = User.new(
        first_name: 'Pompei',
        last_name: '1er',
        short_desc: 'The last King',
        long_desc: '...'
      )

      params = {
        google_token: @current_user.google_token,
        query: update_user_mutation_spec(user_update_infos)
      }

      post '/graphql', params: params

      json = JSON.parse(response.body)
      data = json['data']['updateUser']

      gql_user = data['currentUser']
      compare_gql_and_db_current_users(gql_user, @current_user.reload)

      gql_location = gql_user['location']
      compare_gql_and_db_location(gql_location, @current_user_location.reload, true)
    end
  end

  def update_user_mutation_spec(user_update_infos)
    "
    mutation {
      updateUser(input: {
        user: {
          firstName: \"#{user_update_infos.first_name}\",
          lastName: \"#{user_update_infos.last_name}\",
          shortDesc: \"#{user_update_infos.short_desc}\",
          longDesc: \"#{user_update_infos.long_desc}\"
        }
      })
      {
        currentUser {
          #{current_user_type_attributes}
          location {
            #{location_type_attributes}
          }
        }
      }
    }
    "
  end
end
