# frozen_string_literal: true

module Mutations
  class AuthenticationUser < BaseMutation
    argument :auth, Types::AuthenticationInput, required: true
    argument :api_key, String, required: true

    field :current_user, Types::CurrentUserType, null: true
    field :new, Boolean, null: true

    def resolve(auth:, api_key:)
      raise GraphQL::ExecutionError, 'Invalid API key' unless api_key == ENV['EXPRESS_API_KEY']

      user = User.find_or_initialize_by(
        email: auth[:email]
      )

      new = user.new_record? ? true : false

      user.first_name = auth[:first_name]
      user.last_name = auth[:last_name]
      user.google_token = auth[:google_token]

      user.save

      { current_user: user, new: new }
    end
  end
end
