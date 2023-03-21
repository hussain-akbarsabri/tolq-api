# frozen_string_literal: true

FactoryBot.define do
  factory :language_code do
    code { 'en' }
    country { 'United States' }
  end
end
