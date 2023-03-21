# frozen_string_literal: true

class CreateGlossaries < ActiveRecord::Migration[7.0]
  def change
    create_table :glossaries do |t|
      t.references :source_language_code, foreign_key: { to_table: :language_codes }
      t.references :target_language_code, foreign_key: { to_table: :language_codes }
      t.timestamps
    end

    add_index :glossaries, [:source_language_code_id, :target_language_code_id], unique: true, name: 'idx_unique_glossaries'
  end
end
