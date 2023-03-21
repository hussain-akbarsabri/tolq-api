# frozen_string_literal: true

class Term < ApplicationRecord
  belongs_to :glossary

  validates :source_text, presence: true, length: { minimum: 2 }
  validates :target_text, presence: true, length: { minimum: 2 }
end
