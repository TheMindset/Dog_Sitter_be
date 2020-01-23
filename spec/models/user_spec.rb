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

require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'associations' do
    let(:user) { build(:user) }

    it { is_expected.to have_many(:dogs).dependent(:destroy) }
    it { is_expected.to have_one(:location).dependent(:destroy) }
  end

  describe 'instance method' do
    it '#haversine_distance_to to a user in miles' do
      user = create(:user)
      location = instance_double("Location", lat: 48.85819170000001, long: 2.3525905)
      allow(user).to receive(:location) { location }

      second_user = create(:user)
      second_location = instance_double("Location", lat: 44.7963814, long: -0.6019479)
      allow(second_user).to receive(:location) { second_location }

      expect(user.haversine_distance_to(second_user)).to be_within(502).of(506)
    end
  end
end
