# frozen_string_literal: true

class LanguageCode < ApplicationRecord
  validates :code, uniqueness: true, presence: true, length: { is: 2 }
  validates :country, presence: true, length: { minimum: 3 }
end
