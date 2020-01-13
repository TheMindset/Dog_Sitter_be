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

require 'rails_helper'

RSpec.describe Dog, type: :model do
  it "has a valid factory" do
    expect(build(:dog)).to be_valid
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:activity_level) }
    it { is_expected.to validate_presence_of(:birthdate) }
    it { is_expected.to validate_presence_of(:breed) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:weight) }
  end

  describe 'associations' do
    let(:dog) { build(:dog) }

    it { is_expected.to belong_to(:user) }
  end
end
