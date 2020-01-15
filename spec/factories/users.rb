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

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.unique.first_name }
    last_name { Faker::Name.unique.last_name }
    email { Faker::Internet.unique.email }
    long_desc { Faker::Lorem.paragraph_by_chars(number: 256, supplemental: false) }
    short_desc { Faker::ChuckNorris.fact }
  end
end
