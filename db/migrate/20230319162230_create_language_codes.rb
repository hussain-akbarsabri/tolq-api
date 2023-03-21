# frozen_string_literal: true

class CreateLanguageCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :language_codes do |t|
      t.string :code, limit: 2, null: false
      t.string :country, null: false
    end
    
    add_index :language_codes, :code, unique: true
  end
end
