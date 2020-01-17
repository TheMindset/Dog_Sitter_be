# frozen_string_literal: true

require 'rails_helper'
require 'pry'

RSpec.describe 'Users query', type: :request do
  it 'returns a list of users' do
    users = create_list(:user, 5)
    dogs = create_list(:dog, 3, user: users.first)

    post '/graphql', params: { query: query }
    json = JSON.parse(response.body)
    data = json['data']['users']

    expect(data.count).to eq(5)

    first_db_user = users.first
    first_gql_user = data.first

    compare_gql_and_db_ursers(first_gql_user, first_db_user)

    first_gql_dog = data.first['dogs']
    first_db_dog = dogs

    compare_gql_and_db_dogs(first_gql_dog, first_db_dog)
  end

  def query
    <<~GQL
      query {
        users {
          #{user_type_attributes}
          dogs {
            #{dog_type_attributes}
          }
        }
      }
    GQL
  end
end
