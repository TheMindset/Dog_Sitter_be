# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    # field :email, String, null: true
    field :first_name, String, null: true
    # field :last_name, String, null: true
    field :short_desc, String, null: true
    field :long_desc, String, null: true
    # field :location, Types::LocationType, null: true
    field :dogs, [Types::DogType], null: true
    field :distance, Float, null: true

    def distance
      current_user = context[:current_user]

      current_user.haversine_distance_to(object) if current_user&.location
    end
  end
end
