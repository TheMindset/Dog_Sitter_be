# frozen_string_literal: true

module Types
  class LocationType < Types::BaseObject
    field :id, ID, null: false
    field :state, String, null: true
    field :city, String, null: true
    field :street_address, String, null: true
    field :zip_code, String, null: true
    field :lat, Float, null: true
    field :long, Float, null: true
    field :user, Types::UserType, null: true
    field :dog, Types::DogType, null: true
  end
end
