# frozen_string_literal: true

module Mutations
  class LogOutUser < BaseMutation
    field :message, String, null: true

    def resolve
      boot_unauthorized_user

      context[:current_user].update(google_token: nil)

      { message: 'User has been logged out' }
    end
  end
end
