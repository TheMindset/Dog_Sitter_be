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

require 'rails_helper'

RSpec.describe Location, type: :model do
  it "has a valid factory" do
    expect(build(:location)).to be_valid
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:zip_code) }
  end

  describe 'associations' do
    let(:location) { build(:location) }

    it { is_expected.to belong_to(:user) }
  end
end
