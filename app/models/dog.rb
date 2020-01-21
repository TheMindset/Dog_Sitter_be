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

class Dog < ApplicationRecord
  validates :name, :breed, :birthdate, :weight, :activity_level, presence: true
  validates :activity_level, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 3 }

  belongs_to :user
  has_one :location, through: :user

  def age
    (Time.zone.now - birthdate.to_time) / 1.year.seconds
  end
end
