# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TranslationsController, type: :controller do
  let!(:language_code) { create(:language_code) }

  describe '#create' do
    let(:source_language_code) { LanguageCode.create!(code: 'zh', country: 'Chinese') }
    let(:target_language_code) { LanguageCode.create!(code: 'zu', country: 'Zulu') }
    context 'when missing params' do
      it 'returns a missing params response' do
        post :create, params: {}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to eq('Required params are missing')
      end
    end

    context 'when valid params' do
      it 'creates a new translation' do
        post :create,
             params: { source_language_code: source_language_code.code, target_language_code: target_language_code.code,
                       source_text: 'this is test' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['source_text']).to eq('this is test')
      end
    end
  end

  describe '#show' do
    let(:source_language_code) { LanguageCode.create!(code: 'zh', country: 'Chinese') }
    let(:target_language_code) { LanguageCode.create!(code: 'zu', country: 'Zulu') }
    let(:glossary) do
      Glossary.create!(source_language_code_id: source_language_code.id,
                       target_language_code_id: target_language_code.id)
    end
    let!(:translation) do
      create(:translation, glossary_id: glossary.id, source_text: 'I am here',
                           source_language_code_id: source_language_code.id,
                           target_language_code_id: target_language_code.id)
    end
    let!(:term) { create(:term, glossary: glossary, source_text: 'here', target_text: 'hiii') }

    context 'when glossary is present' do
      it 'highlights the matching text in source_text' do
        get :show, params: { id: translation.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['source_text']).to eq('I am <HIGHLIGHT>here</HIGHLIGHT>')
      end
    end

    context 'when glossary is not present' do
      let!(:translation) do
        create(:translation, source_text: 'I am here', source_language_code_id: source_language_code.id,
                             target_language_code_id: target_language_code.id)
      end

      it 'does not highlight anything in source_text' do
        get :show, params: { id: translation.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['source_text']).to eq(translation.source_text)
      end
    end
  end
end
