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
#  short_des      :text
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
  pending "add some examples to (or delete) #{__FILE__}"
end
