# frozen_string_literal: true

class Translation < ApplicationRecord
  belongs_to :source_language_code, class_name: 'LanguageCode', foreign_key: 'source_language_code_id'
  belongs_to :target_language_code, class_name: 'LanguageCode', foreign_key: 'target_language_code_id'
  belongs_to :glossary, optional: true

  validates :source_text, presence: true, length: { maximum: 5000 }
  validate :check_glossary_validity, if: -> { glossary_id.present? }

  private

  def check_glossary_validity
    unless glossary.source_language_code_id == source_language_code_id && glossary.target_language_code_id == target_language_code_id
      errors.add(:base, 'Source and target language codes do not match with the glossary')
    end
  end
end
