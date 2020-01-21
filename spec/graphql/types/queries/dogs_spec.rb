# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dog query', type: :request do
  let!(:user1) { create(:user ) }
  let!(:user2) { create(:user ) }

  let!(:dog1) { create(:dog, user: user1, breed: 'Charo', activity_level: 0, birthdate: '2009-03-18', weight: 15) }
  let!(:dog2) { create(:dog, user: user1, breed: 'CharoMignon', activity_level: 1, birthdate: '2008-03-18', weight: 24) }
  let!(:dog3) { create(:dog, user: user1, breed: 'CharoSauvage', activity_level: 0, birthdate: '2011-03-18', weight: 45) }

  let!(:dog4) { create(:dog, user: user2, breed: 'CharoElegant', activity_level: 2, birthdate: '2015-03-18', weight: 50) }
  let!(:dog5) { create(:dog, user: user2, breed: 'CharoMechant', activity_level: 1, birthdate: '2005-03-18', weight: 55) }
  let!(:dog6) { create(:dog, user: user2, breed: 'CharoMechantMechant', activity_level: 3, birthdate: '2010-03-18', weight: 35) }

  it 'return a list of dogs' do
    query = " query {
      dogs() {
        #{dog_type_attributes}
        user {
          #{user_type_attributes}
        }
      }
    }
    "
    post '/graphql', params: { query: query }

    json = JSON.parse(response.body)
    data = json['data']['dogs']

    first_db_dog = dog1
    first_gql_dog = data.first

    expect(data.count).to eq(6)
    compare_gql_and_db_dogs(first_gql_dog, first_db_dog)

    first_db_user = user1
    first_gql_user = data.first['user']
    compare_gql_and_db_users(first_gql_user, first_db_user)
  end

  it 'return a list of dogs fitlered by activity_level' do
    query = query('activityLevelRange: [2, 3]')

    post '/graphql', params: { query: query }

    json = JSON.parse(response.body)
    data = json['data']['dogs']

    first_gql_dog = data.first
    first_db_dog = dog4

    compare_gql_and_db_dogs(first_gql_dog, first_db_dog)
  end

  it 'return a list of dogs fitlered by age' do
    query = query('ageRange: [5, 10]')

    post '/graphql', params: { query: query }

    json = JSON.parse(response.body)
    data = json['data']['dogs']

    first_gql_dog = data.first
    first_db_dog = dog1

    compare_gql_and_db_dogs(first_gql_dog, first_db_dog)
  end

  it 'return a list of dogs fitlered by weight' do
    query = query('weightRange: [30, 50]')

    post '/graphql', params: { query: query }

    json = JSON.parse(response.body)
    data = json['data']['dogs']

    first_gql_dog = data.first
    first_db_dog = dog3

    compare_gql_and_db_dogs(first_gql_dog, first_db_dog)
  end

  it 'return a list of dogs fitlered by breed' do
    query = query('breed: "CharoMechantMechant"')

    post '/graphql', params: { query: query }

    json = JSON.parse(response.body)
    data = json['data']['dogs']

    first_gql_dog = data.first
    first_db_dog = dog6

    compare_gql_and_db_dogs(first_gql_dog, first_db_dog)
  end

  def query(argument)
    <<~GQL
      query {
        dogs(#{argument}) {
          #{dog_type_attributes}
          user {
            #{user_type_attributes}
          }
        }
      }
    GQL
  end
end
