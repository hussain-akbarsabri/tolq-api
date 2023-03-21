# frozen_string_literal: true

class CreateTerms < ActiveRecord::Migration[7.0]
  def change
    create_table :terms do |t|
      t.string :source_text, null: false
      t.string :target_text, null: false
      t.references :glossary, null: false, foreign_key: true

      t.timestamps
    end
  end
end
