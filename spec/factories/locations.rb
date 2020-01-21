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

FactoryBot.define do
  factory :location do
    street_address { "MyText" }
    city { "MyString" }
    state { "MyString" }
    zip_code { "MyString" }
    lat { 1.5 }
    long { 1.5 }
    user { nil }
  end
end
