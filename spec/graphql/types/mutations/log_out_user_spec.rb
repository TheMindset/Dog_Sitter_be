# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'LogOut', type: :request do
  it 'logout a user logged in' do
    user = create(:user)

    mutation = log_out_user(user)

    post '/graphql', params: { google_token: user.google_token, query: mutation }

    json = JSON.parse(response.body, symbolize_names: true)
    data = json[:data][:logOutUser]

    expect(data[:message]).to eq('User has been logged out')
  end

  it 'does not log out user logged in' do
    # double() imitate a reel object
    user = double(
      first_name: 'Quantin',
      last_name: 'Tarantino I',
      email: 'qTarantinoI@yopmail.com',
      google_token: 'testsecondtoken'
    )

    mutation = log_out_user(user)

    post '/graphql', params: { google_token: user.google_token, query: mutation }

    json = JSON.parse(response.body, symbolize_names: true)
    data = json[:errors][0]

    expect(data[:message]).to eq('Unauthorized - a valid google_token query parameter is required')
  end

  def log_out_user(_user)
    "
    mutation {
      logOutUser(input: {

      }){
       message
      }
    }
    "
  end
end
