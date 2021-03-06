# frozen_string_literal: true

class GeocoderService
  attr_reader :location

  def initialize(input = {})
    @location = input[:location]
  end

  def geocode
    get_json("maps/api/geocode/json")
  end

  private

  def conn
    @conn ||= Faraday.new(url: "https://maps.googleapis.com/") do |faraday|
      faraday.params["key"] = ENV['GOOGLE_MAPS_API_KEY']
      faraday.params["address"] = @location
      faraday.adapter Faraday.default_adapter
    end
  end

  def get_json(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
end
