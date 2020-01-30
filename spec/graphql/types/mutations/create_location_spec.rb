# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CreateLocation', type: :request do
  before do
    @user = create(:user)
  end

  describe 'with a valid google_token and location informations' do
    it 'current user can create a new location' do
      VCR.use_cassette('create_location_mutation/with_valide_informations') do
        location = Location.new(
          street_address: '680 Cours de la Libération',
          zip_code: '33405',
          city: 'Talence',
          state: 'France'
        )

        params = {
          google_token: @user.google_token,
          query: location_mutation(location)
        }

        post '/graphql', params: params

        json = JSON.parse(response.body)

        gql_location = json['data']['createLocation']['location']

        compare_gql_and_db_location(gql_location, location, false)
      end
    end
  end

  describe 'with an invalid google_token and a valid location informations' do
    it 'user can not create a new location' do
      location = Location.new(
        street_address: '680 Cours de la Libération',
        zip_code: '33405',
        city: 'Talence',
        state: 'France'
      )

      params = {
        google_token: nil,
        query: location_mutation(location)
      }

      post '/graphql', params: params

      json = JSON.parse(response.body)
      errors = json['errors'].first['message']

      expect(errors).to eq('Unauthorized - a valid google_token query parameter is required')
    end
  end

  describe 'with valid google_token and invalid location informations' do
    it 'user can not create a new location' do
      VCR.use_cassette('create_location_mutation/with_invalide_location') do
        location = Location.new(
          street_address: -5,
        )

        params = {
          google_token: @user.google_token,
          query: location_mutation(location)
        }

        post '/graphql', params: params

        json = JSON.parse(response.body)
        gql_location = json['data']['createLocation']['location']

        expect(gql_location).to be_nil
      end
    end
  end

  def location_mutation(location)
    "
    mutation {
      createLocation(input: {
        location: {
          streetAddress: \"#{location.street_address}\",
          zipCode: \"#{location.zip_code}\",
          city: \"#{location.city}\",
          state: \"#{location.state}\"
        }
      })
      {
        location {
          #{location_type_attributes}
        }
      }
    }
    "
  end
end
