# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AuthenticationUser', type: :request do
  before do
    @user_in_db = create(:user)

    @api_key = ENV['EXPRESS_API_KEY']
  end

  describe 'sent a valid API key and a existing user in database' do
    it 'return the user info' do
      mutation = authentication_user_query(@user_in_db, @api_key)
      post '/graphql', params: { query: mutation }

      json = JSON.parse(response.body, symbolize_names: true)
      data = json[:data][:authenticationUser]

      expect(data[:currentUser]).to include(
        firstName: @user_in_db.first_name,
        lastName: @user_in_db.last_name,
        email: @user_in_db.email
      )

      expect(data[:new]).to eq(false)
    end
  end

  describe 'sent a valid API with no user in database' do
    it 'create and return new user' do
      user = double(
        first_name: 'Quantin',
        last_name: 'Tarantino I',
        email: 'qTarantinoI@yopmail.com',
        google_token: 'testsecondtoken'
      )

      mutation = authentication_user_query(user, @api_key)
      post '/graphql', params: { query: mutation }

      json = JSON.parse(response.body, symbolize_names: true)
      data = json[:data][:authenticationUser]

      expect(data[:currentUser]).to include(
        firstName: user.first_name,
        lastName: user.last_name,
        email: user.email
      )
      expect(data[:new]).to eq(true)
    end
  end

  describe 'sent invalid API key' do
    it 'does not return an authenticate user' do
      invalid_api_key = ''

      mutation = authentication_user_query(@user_in_db, invalid_api_key)
      post '/graphql', params: { query: mutation }

      json = JSON.parse(response.body, symbolize_names: true)

      data = json[:data][:authenticationUser]
      errors_message = json[:errors][0][:message]

      expect(data).to be_nil
      expect(errors_message).to eq('Invalid API key')
    end
  end

  def authentication_user_query(user, api_key)
    "
    mutation {
      authenticationUser(input: {
        apiKey: \"#{api_key}\",
        auth: {
          firstName: \"#{user.first_name}\",
          lastName: \"#{user.last_name}\",
          email: \"#{user.email}\",
          googleToken: \"#{user.google_token}\"
        }
      }) {
        currentUser {
          #{current_user_type_attributes}
        }
        new
      }

    }
    "
  end
end
