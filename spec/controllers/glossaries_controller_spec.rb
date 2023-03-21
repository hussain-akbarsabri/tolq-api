# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GlossariesController, type: :controller do
  describe 'POST #create' do
    context 'with valid params' do
      let!(:source_language_code) { LanguageCode.create!(code: 'zh', country: 'Chinese') }
      let!(:target_language_code) { LanguageCode.create!(code: 'zu', country: 'Zulu') }
      let(:valid_params) do
        { source_language_code: source_language_code.code, target_language_code: target_language_code.code }
      end

      it 'creates a new Glossary' do
        expect do
          post :create, params: valid_params
        end.to change(Glossary, :count).by(1)
      end

      it 'returns a success response' do
        post :create, params: valid_params
        expect(response).to be_successful
      end
    end

    context 'with missing params' do
      it 'returns a missing params error response' do
        post :create, params: { source_language_code: 'en' }
        error = JSON.parse(response.body)
        expect(error['message']).to eq('Required params are missing')
        expect(response.status).to eq(422)
      end
    end

    context 'with already persisted record' do
      let!(:source_language_code1) { LanguageCode.create!(code: 'sq', country: 'Albanian') }
      let!(:target_language_code1) { LanguageCode.create(code: 'tn', country: 'Tswana') }
      let!(:glossary1) do
        Glossary.create!(source_language_code_id: source_language_code1.id,
                         target_language_code_id: target_language_code1.id)
      end
      it 'returns a error response regarding uniqueness' do
        post :create,
             params: { source_language_code: source_language_code1.code,
                       target_language_code: target_language_code1.code }
        error = JSON.parse(response.body)
        expect(error['message']).to eq(['Source language code has already been taken with respect to target language code'])
        expect(response.status).to eq(400)
      end
    end
  end

  describe 'GET #index' do
    let(:source_language_code) { LanguageCode.create(code: 'zh', country: 'Chinese') }
    let(:target_language_code) { LanguageCode.create(code: 'zu', country: 'Zulu') }
    let!(:target_language_code1) { LanguageCode.create(code: 'tn', country: 'Tswana') }
    let!(:glossary1) do
      Glossary.create!(source_language_code_id: source_language_code.id,
                       target_language_code_id: target_language_code.id)
    end
    let!(:glossary2) do
      Glossary.create!(source_language_code_id: source_language_code.id,
                       target_language_code_id: target_language_code1.id)
    end
    let!(:term1) { Term.create(glossary: glossary1, source_text: 'hello', target_text: 'hehe') }
    let!(:term2) { Term.create(glossary: glossary1, source_text: 'hi', target_text: 'hey') }

    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns all glossaries' do
      get :index
      expect(JSON.parse(response.body).size).to eq(2)
    end

    it 'returns all glossaries with associated terms' do
      get :index
      expect(JSON.parse(response.body)).to eq([
                                                {
                                                  'id' => glossary1.id,
                                                  'source_language_code_id' => source_language_code.id,
                                                  'target_language_code_id' => target_language_code.id,
                                                  'terms' => [
                                                    { 'id' => term1.id, 'source_text' => term1.source_text,
                                                      'target_text' => term1.target_text, 'glossary_id' => glossary1.id },
                                                    { 'id' => term2.id, 'source_text' => term2.source_text,
                                                      'target_text' => term2.target_text, 'glossary_id' => glossary1.id }
                                                  ]
                                                },
                                                {
                                                  'id' => glossary2.id,
                                                  'source_language_code_id' => source_language_code.id,
                                                  'target_language_code_id' => target_language_code1.id,
                                                  'terms' => []
                                                }
                                              ])
    end
  end

  describe 'GET #show' do
    let(:source_language_code) { LanguageCode.create!(code: 'zh', country: 'Chinese') }
    let(:target_language_code) { LanguageCode.create!(code: 'zu', country: 'Zulu') }
    let(:glossary) do
      Glossary.create(source_language_code_id: source_language_code.id,
                      target_language_code_id: target_language_code.id)
    end
    let!(:term1) { Term.create(glossary: glossary, source_text: 'hello', target_text: 'hehe') }
    let!(:term2) { Term.create(glossary: glossary, source_text: 'hi', target_text: 'hey') }

    context 'with valid params' do
      it 'returns a success response' do
        get :show, params: { id: glossary.id }
        expect(response).to be_successful
      end

      it 'returns the correct glossary' do
        get :show, params: { id: glossary.id }
        expect(JSON.parse(response.body)).to eq(
          {
            'id' => glossary.id,
            'source_language_code_id' => source_language_code.id,
            'target_language_code_id' => target_language_code.id,
            'terms' => [
              { 'id' => term1.id, 'source_text' => term1.source_text, 'target_text' => term1.target_text,
                'glossary_id' => glossary.id },
              { 'id' => term2.id, 'source_text' => term2.source_text, 'target_text' => term2.target_text,
                'glossary_id' => glossary.id }
            ]
          }
        )
      end
    end

    context 'with invalid params' do
      it 'returns record not found exception' do
        get :show, params: { id: 0 }
        expect(JSON.parse(response.body)['message']).to eq('Record not found')
      end
    end
  end
end
