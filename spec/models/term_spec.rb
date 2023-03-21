# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Term, type: :model do
  let(:glossary) { Glossary.create }

  describe 'associations' do
    it { should belong_to(:glossary) }
  end

  describe 'validations' do
    it 'requires source_text to be present' do
      term = glossary.terms.new(source_text: nil, target_text: 'Test target')
      expect(term).not_to be_valid
    end

    it 'requires target_text to be present' do
      term = glossary.terms.new(source_text: 'Test source', target_text: nil)
      expect(term).not_to be_valid
    end

    it 'requires source_text to be at least 2 character long' do
      term = glossary.terms.new(source_text: '', target_text: 'Test target')
      expect(term).not_to be_valid
    end

    it 'requires target_text to be at least 2 character long' do
      term = glossary.terms.new(source_text: 'Test source', target_text: '')
      expect(term).not_to be_valid
    end

    it 'validates a term with source and target text' do
      term = glossary.terms.new(source_text: 'Test source', target_text: 'Test target')
      expect(term).to be_valid
    end
  end
end
