# frozen_string_literal: true

class Glossary < ApplicationRecord
  belongs_to :source_language_code, class_name: 'LanguageCode', foreign_key: 'source_language_code_id'
  belongs_to :target_language_code, class_name: 'LanguageCode', foreign_key: 'target_language_code_id'
  has_many :terms, dependent: :destroy
  has_one :translation, dependent: :destroy

  validates :source_language_code_id,
            uniqueness: { scope: [:target_language_code_id],
                          message: 'has already been taken with respect to target language code' }
end
