# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  email        :string
#  first_name   :string
#  google_token :string
#  last_name    :string
#  long_desc    :text
#  short_desc   :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_users_on_google_token  (google_token)
#

class User < ApplicationRecord
  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }

  has_one :location, dependent: :destroy
  has_many :dogs, dependent: :destroy

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
