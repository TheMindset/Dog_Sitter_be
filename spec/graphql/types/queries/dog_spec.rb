# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dog query', type: :request do
  describe 'as a visitor' do
    it 'returns a dog by id' do
      user = create(:user)
      dog = create(:dog, user: user)

      post '/graphql', params: { query: query(id: dog.id) }

      json = JSON.parse(response.body)
      data = json['data']['dog']

      compare_gql_and_db_dogs(data, dog)
      expect(data[:distance]).to be_nil

      # TODO (if distance fiel is request return nil for user)
      # gql_user = data['user']
      # compare_gql_and_db_users(gql_user, user)
      # expect(gql_user[:distance]).to be_nil
    end

    it 'has an error if no dog with that id' do
      dog = create(:dog)

      post '/graphql', params: { query: query(id: dog.id + 1) }
      json = JSON.parse(response.body, symbolize_names: true)

      error_message = json[:errors][0][:message]
      expect(error_message).to eq("Couldn't find Dog with 'id'=#{dog.id + 1}")

      data = json[:data]
      expect(data).to be_nil
    end
  end

  describe 'as an authenticated user' do
    before do
      VCR.use_cassette('authenticated_dog_query_spec/before_each') do
        @current_user = create(:user)

        Location.create!(
          user: @current_user,
          street_address: "680 Cours de la Libération",
          zip_code: 33_405,
          city: 'Talence',
          state: 'France'
        )
      end
    end

    it 'returns a dog by id' do
      user = create(:user)

      VCR.use_cassette('authenticated_dog_query_spec/other_user') do
        Location.create!(
          user: user,
          street_address: '52 Rue de la Verrerie',
          zip_code: 75_003,
          city: 'Paris',
          state: 'France'
        )
      end

      dog = create(:dog, user: user)

      make_authenticated_post_request(query(id: dog.id))

      json = JSON.parse(response.body)
      data = json['data']['dog']

      compare_gql_and_db_dogs(data, dog)
      expect(data['distance']).to eq(504.3975824986352)

      gql_user = data['user']
      compare_gql_and_db_users(gql_user, user)
      expect(gql_user['distance']).to eq(504.3975824986352)
    end

    it 'has an error if no dog with that id' do
      dog = create(:dog)

      make_authenticated_post_request(query(id: dog.id + 1))

      json = JSON.parse(response.body, symbolize_names: true)

      error_message = json[:errors][0][:message]
      expect(error_message).to eq("Couldn't find Dog with 'id'=#{dog.id + 1}")

      data = json[:data]
      expect(data).to be_nil
    end
  end

  def query(id:)
    <<~GQL
      query {
        dog(id: #{id}) {
          #{dog_type_attributes}
          user {
            #{user_type_attributes}
          }
        }
      }
    GQL
  end

  def make_authenticated_post_request(query)
    post '/graphql', params: { google_token: @current_user.google_token, query: query }
  end
end
