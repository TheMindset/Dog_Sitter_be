# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :log_out_user, mutation: Mutations::LogOutUser
    field :authentication_user, mutation: Mutations::AuthenticationUser
    # field :create_user, mutation: Mutations::CreateUser
  end
end
