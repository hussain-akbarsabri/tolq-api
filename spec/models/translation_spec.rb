# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Translation, type: :model do
  let(:source_language_code) { LanguageCode.create!(code: 'zh', country: 'Chinese') }
  let(:target_language_code) { LanguageCode.create!(code: 'zu', country: 'Zulu') }
  let!(:target_language_code1) { LanguageCode.create(code: 'tn', country: 'Tswana') }
  let(:glossary) do
    Glossary.create(source_language_code_id: source_language_code.id, target_language_code_id: target_language_code.id)
  end

  describe 'associations' do
    it { should belong_to(:source_language_code).class_name('LanguageCode') }
    it { should belong_to(:target_language_code).class_name('LanguageCode') }
    it { should belong_to(:glossary).optional }
  end

  describe 'validations' do
    it { should validate_length_of(:source_text).is_at_most(5000) }

    context 'when glossary_id is present' do
      subject do
        Translation.new(source_text: 'Test', source_language_code: source_language_code,
                        target_language_code: target_language_code, glossary_id: glossary.id)
      end

      context 'when the glossary is valid' do
        it 'should be valid' do
          expect(subject).to be_valid
        end
      end

      context 'when the glossary is invalid' do
        before { glossary.update(target_language_code: LanguageCode.create(country: 'German', code: 'de')) }

        it 'should not be valid' do
          expect(subject).not_to be_valid
        end

        it 'should have an error message' do
          subject.valid?
          expect(subject.errors.full_messages).to include('Source and target language codes do not match with the glossary')
        end
      end
    end
  end
end
