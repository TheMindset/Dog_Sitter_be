# frozen_string_literal: true

module Types
  class LocationInput < BaseInputObject
    argument :street_address, String, required: true
    argument :state, String, required: true
    argument :city, String, required: true
    argument :zip_code, String, required: true
  end
end
