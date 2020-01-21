# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dog query', type: :request do
  it 'return user by ID' do
    user = create(:user)
    dog = create(:dog, user: user)

    post '/graphql', params: { query: query(id: dog.id) }

    json = JSON.parse(response.body)
    data = json['data']['dog']

    first_gql_dog = data
    first_db_dog = dog

    compare_gql_and_db_dogs(first_gql_dog, first_db_dog)
  end

  it 'return an error if no user with id is found' do
    dog = create(:dog)

    post '/graphql', params: { query: query(id: dog.id + 1) }

    json = JSON.parse(response.body)
    error_message = json['errors'].first['message']

    expect(error_message).to eq("Couldn't find Dog with 'id'=#{dog.id + 1}")
  end

  def query(id:)
    <<~GQL
      query {
        dog(id: #{id}) {
          #{dog_type_attributes}
        }
      }
    GQL
  end
end
