# frozen_string_literal: true

module Mutations
  class CreateLocation < BaseMutation
    argument :location, Types::LocationInput, required: true

    field :location, Types::LocationType, null: true

    def resolve(location:)
      boot_unauthorized_user

      begin
        location = context[:current_user].create_location(
          street_address: location[:street_address],
          city: location[:city],
          state: location[:state],
          zip_code: location[:zip_code]
        )
      rescue RuntimeError => e
        raise GraphQL::ExecutionError, e.message
      end

      { location: location }
    end
  end
end
