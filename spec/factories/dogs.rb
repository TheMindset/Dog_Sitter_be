# frozen_string_literal: true

# == Schema Information
#
# Table name: dogs
#
#  id             :bigint           not null, primary key
#  activity_level :integer
#  birthdate      :date
#  breed          :string
#  long_desc      :text
#  name           :string
#  short_desc     :text
#  weight         :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint
#
# Indexes
#
#  index_dogs_on_user_id  (user_id)
#

FactoryBot.define do
  factory :dog do
    name { Faker::Artist.unique.name }
    birthdate { Faker::Date.between(from: 2.days.ago, to: Date.today) }
    activity_level { rand(3) }
    breed { Faker::Creature::Dog.breed }
    long_desc { Faker::Lorem.paragraph_by_chars(number: 256, supplemental: false) }
    short_desc { Faker::ChuckNorris.fact }
    weight { rand(30) }
    user { FactoryBot.create(:user) }
  end
end
