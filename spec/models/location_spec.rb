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

  describe 'before_save_location' do
    before do
      user = create(:user)

      VCR.use_cassette('before_save_on_model_creation') do
        @location = described_class.create!(
          user: user,
          street_address: '52 Rue de la Verrerie',
          zip_code: 75_003,
          city: 'Paris',
          state: 'France'
        )
      end
    end

    it 'update lat/lng on model creation' do
      expect(@location.lat).to eq(48.85819170000001)
      expect(@location.long).to eq(2.3525905)
    end

    it 'update lat/lng on model update' do
      VCR.use_cassette('before_save_on_model_update') do
        @location.update(
          street_address: "680 Cours de la Libération",
          zip_code: 33_405,
          city: 'Talence',
          state: 'France'
        )
      end

      expect(@location.lat).to eq(44.7963814)
      expect(@location.long).to eq(-0.6019479)
    end

    it 'throw an error if invalid address provided' do
      VCR.use_cassette('before_save_on_model_update/invalid_location') do
        user = create(:user)

        expect {
          @location = described_class.create(
            user: user,
            zip_code: "ssss"
          )
        }.to raise_error(RuntimeError, 'Invalid address entered')
      end
    end
  end
end
