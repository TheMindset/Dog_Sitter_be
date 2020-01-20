# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dog query', type: :request do
  it 'return a list of dogs' do
    user = create(:user)
    dogs = create_list(:dog, 3, user: user)

    post '/graphql', params: { query: query }

    json = JSON.parse(response.body)
    data = json['data']['dogs']

    first_db_dog = dogs.first
    first_gql_dog = data.first

    expect(data.count).to eq(3)
    compare_gql_and_db_dogs(first_gql_dog, first_db_dog)

    first_db_user = user
    first_gql_user = data.first['user']
    compare_gql_and_db_users(first_gql_user, first_db_user)
  end

  def query
    <<~GQL
      query {
        dogs {
          #{dog_type_attributes}
          user {
            #{user_type_attributes}
          }
        }
      }
    GQL
  end
end
