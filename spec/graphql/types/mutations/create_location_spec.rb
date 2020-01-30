# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CreateLocation', type: :request do
  before do
    @user = create(:user)
  end

  describe 'with a valid google_token and lacation informations' do
    it 'current user can create a new location' do
      VCR.use_cassette('create_location_validation/with_valide_inforamtions') do
        location = Location.new(
          street_address: '680 Cours de la Libération',
          zip_code: '33405',
          city: 'Talence',
          state: 'France'
        )

        params = {
          google_token: @user.google_token,
          query: valide_location_mutation(location)
        }

        post '/graphql', params: params

        json = JSON.parse(response.body)

        gql_location = json['data']['createLocation']['location']

        compare_gql_and_db_location(gql_location, location, false)
      end
    end
  end

  def valide_location_mutation(location)
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
