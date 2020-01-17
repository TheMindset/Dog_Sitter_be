# frozen_string_literal: true

require 'rails_helper'
require 'pry'

RSpec.describe 'Users query', type: :request do
  it 'returns a list of users' do
    users = create_list(:user, 5)

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
        }
      }
    GQL
  end
end
