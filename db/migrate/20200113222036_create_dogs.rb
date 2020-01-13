# frozen_string_literal: true

class CreateDogs < ActiveRecord::Migration[5.2]
  def change
    create_table :dogs do |t|
      t.string :name
      t.string :breed
      t.date :birthdate
      t.integer :weight
      t.text :short_desc
      t.text :long_desc
      t.integer :activity_level
      t.belongs_to :user

      t.timestamps
    end
  end
end
