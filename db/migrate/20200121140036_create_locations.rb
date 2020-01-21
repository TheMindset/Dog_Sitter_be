# frozen_string_literal: true

class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.text :street_address
      t.string :city
      t.string :state
      t.string :zip_code
      t.float :lat
      t.float :long
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
