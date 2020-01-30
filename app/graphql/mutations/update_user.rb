# frozen_string_literal: true

module Mutations
  class UpdateUser < BaseMutation
    argument :user, Types::UserInput, required: false
    argument :location, Types::LocationInput, required: false

    field :current_user, Types::CurrentUserType, null: true

    def resolve(user: nil, location: nil)
      boot_unauthorized_user

      current_user = context[:current_user]

      current_user.update(user.to_hash) if user
      current_user.update(location.to_hash) if location

      { current_user: current_user }
    end
  end
end
