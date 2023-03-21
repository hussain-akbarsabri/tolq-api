# frozen_string_literal: true

class CreateTranslations < ActiveRecord::Migration[7.0]
  def change
    create_table :translations do |t|
      t.references :source_language_code, foreign_key: { to_table: :language_codes }
      t.references :target_language_code, foreign_key: { to_table: :language_codes }
      t.references :glossary
      t.text :source_text, null: false

      t.timestamps
    end
  end
end
