# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User query', type: :request do
  it 'return user by ID' do
    user = create(:user)
    dogs = create_list(:dog, 2, user: user)

    post '/graphql', params: { query: query(id: user.id) }

    json = JSON.parse(response.body)
    data = json['data']['user']

    first_gql_user = data
    first_db_user = user

    compare_gql_and_db_users(first_gql_user, first_db_user)

    first_gql_dog = data['dogs'].first
    first_db_dog = dogs.first

    compare_gql_and_db_dogs(first_gql_dog, first_db_dog)
  end

  it 'return an error if no user with id is found' do
    user = create(:user)

    post '/graphql', params: { query: query(id: user.id + 1) }

    json = JSON.parse(response.body)
    error_message = json['errors'].first['message']

    expect(error_message).to eq("Couldn't find User with 'id'=#{user.id + 1}")
  end

  def query(id:)
    <<~GQL
      query {
        user(id: #{id}) {
          #{user_type_attributes}
          dogs {
            #{dog_type_attributes}
          }
        }
      }
    GQL
  end
end
