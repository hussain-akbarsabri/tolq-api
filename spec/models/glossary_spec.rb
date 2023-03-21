# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Glossary, type: :model do
  describe 'associations' do
    it { should belong_to(:source_language_code).class_name('LanguageCode') }
    it { should belong_to(:target_language_code).class_name('LanguageCode') }
    it { should have_many(:terms).dependent(:destroy) }
    it { should have_one(:translation).dependent(:destroy) }
  end

  describe 'validations' do
    subject { FactoryBot.build(:glossary) }

    it {
      should validate_uniqueness_of(:source_language_code_id).scoped_to(:target_language_code_id).with_message('has already been taken with respect to target language code')
    }
  end
end
