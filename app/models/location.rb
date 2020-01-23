# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  id             :bigint           not null, primary key
#  city           :string
#  lat            :float
#  long           :float
#  state          :string
#  street_address :text
#  zip_code       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint
#
# Indexes
#
#  index_locations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Location < ApplicationRecord
  validates :zip_code, presence: true

  belongs_to :user

  before_save :update_lat_lng

  def update_lat_lng
    location = retreive_lat_lng
    self.lat = location[:lat]
    self.long = location[:lng]
  end

  def retreive_lat_lng
    response = geocoder_input_location.geocode
    response[:results].first[:geometry][:location]
  end

  def geocoder_input_location
    GeocoderService.new(location: input_location)
  end

  def input_location
    input_location = "#{street_address}, " if street_address
    input_location += "#{zip_code} " if zip_code
    input_location += "#{city} " if city
    input_location += state.to_s if state
  end
end
