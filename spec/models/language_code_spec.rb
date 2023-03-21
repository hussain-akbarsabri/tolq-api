# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LanguageCode, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      language_code = LanguageCode.new(code: 'en', country: 'USA')
      expect(language_code).to be_valid
    end

    it 'is not valid without a code' do
      language_code = LanguageCode.new(country: 'USA')
      expect(language_code).to_not be_valid
    end

    it 'is not valid with a code that is not 2 characters' do
      language_code = LanguageCode.new(code: 'e', country: 'USA')
      expect(language_code).to_not be_valid
    end

    it 'is not valid without a country' do
      language_code = LanguageCode.new(code: 'en')
      expect(language_code).to_not be_valid
    end

    it 'is not valid with a country that is less than 3 characters' do
      language_code = LanguageCode.new(code: 'en', country: 'US')
      expect(language_code).to_not be_valid
    end
  end
end
