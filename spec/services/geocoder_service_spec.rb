# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GeocoderService do
  it 'initializes with a location' do
    location = '52 Rue de la Verrerie, 75003 Paris'
    service = described_class.new(location: location)

    expect(service.location).to eq(location)
  end

  it 'return API response, which incluge lat and long' do
    VCR.use_cassette('geocoder_response_happy_path', record: :new_episodes) do
      location = '52 Rue de la Verrerie, 75003 Paris'
      service = described_class.new(location: location)

      response = service.geocode
      location_response = response[:results].first[:geometry][:location]

      expect(location_response).to be_a(Hash)
      expect(location_response[:lat]).to eq(48.85819170000001)
      expect(location_response[:lng]).to eq(2.3525905)
    end
  end
end
