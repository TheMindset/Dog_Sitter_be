# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    def boot_unauthorized_user
      raise GraphQL::ExecutionError, 'Unauthorized - a valid google_token query parameter is required' unless context[:current_user]
    end
  end
end
