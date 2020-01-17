# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :users, [Types::UserType], null: false, description: 'Returns a list of users'

    def users
      User.all
    end

    field :user, Types::UserType, null: false,
                                  description: 'Find user by ID' do
      argument :id, ID, required: true
    end

    def user(id:)
      User.find(id)
    end
  end
end
