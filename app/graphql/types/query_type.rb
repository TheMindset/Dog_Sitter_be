# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :users, [Types::UserType], null: false, description: 'Returns a list of users'

    def users
      User.all
    end
  end
end
