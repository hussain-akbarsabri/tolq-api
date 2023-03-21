# frozen_string_literal: true

FactoryBot.define do
  factory :glossary do
    association :source_language_code, factory: :language_code
    association :target_language_code, factory: :language_code
  end
end
