# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string
#  first_name :string
#  last_name  :string
#  long_desc  :text
#  short_desc :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }

  has_one :location, dependent: :destroy
  has_many :dogs, dependent: :destroy

  # def haversine_distance_to(user_or_dog)
  #   radius_of_earth = 6378.14

  #   dlon = ((self.location.long * Math::PI / 180) - (user_or_dog.location.long * Math::PI / 180))
  #   dlat = ((self.location.lat * Math::PI / 180) - (user_or_dog.location.lat * Math::PI / 180))

  #   a = power(Math::sin(dlat/2), 2) + Math::cos(self.location.lat) * Math::cos(user_or_dog.location.lat) * power(Math::sin(dlon/2), 2)
  #   great_circle_distance = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
  #   distance = radius_of_earth * great_circle_distance
  #   binding.pry
  # end

  # def power(num, pow)
  #   num ** pow
  # end

  # def haversine_distance_to(lat1, long1, lat2, long2)
  #   radius_of_earth = 6378.14
  #   rlat1, rlong1, rlat2, rlong2 = [lat1, long1, lat2, long2].map { |d| as_radians(d)}

  #   dlon = rlong1 - rlong2
  #   dlat = rlat1 - rlat2

  #   a = power(Math::sin(dlat/2), 2) + Math::cos(rlat1) * Math::cos(rlat2) * power(Math::sin(dlon/2), 2)
  #   great_circle_distance = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
  #   radius_of_earth * great_circle_distance
  # end

  # def as_radians(degrees)
  #   degrees * Math::PI/180
  # end

  # def power(num, pow)
  #   num ** pow
  # end

  def haversine_distance_to(user_or_dog, miles = false)
    # Formulas based on https://www.movable-type.co.uk/scripts/latlong.html

    d_lat = (user_or_dog.location.lat - location.lat) * Math::PI / 180
    d_long = (user_or_dog.location.long - location.long) * Math::PI / 180

    a = Math.sin(d_lat / 2) *
        Math.sin(d_lat / 2) +
        Math.cos(user_or_dog.location.lat * Math::PI / 180) *
        Math.cos(location.lat * Math::PI / 180) *
        Math.sin(d_long / 2) * Math.sin(d_long / 2)

    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    6371 * c * (miles ? 1 / 1.6 : 1)
  end
end
