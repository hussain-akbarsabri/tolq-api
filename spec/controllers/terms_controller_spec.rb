# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TermsController, type: :controller do
  describe 'POST #create' do
    let(:source_language_code) { LanguageCode.create!(code: 'zh', country: 'Chinese') }
    let(:target_language_code) { LanguageCode.create!(code: 'zu', country: 'Zulu') }
    let(:glossary) do
      Glossary.create!(source_language_code_id: source_language_code.id,
                       target_language_code_id: target_language_code.id)
    end
    let(:valid_params) { { glossary_id: glossary.id, source_term: 'Hello', target_term: 'Hola' } }
    let(:missing_params) { { glossary_id: glossary.id } }
    let(:invalid_params) { { glossary_id: glossary.id, source_term: '', target_term: '' } }

    context 'with valid params' do
      it 'creates a new term' do
        expect do
          post :create, params: valid_params
        end.to change { glossary.terms.count }.by(1)
      end

      it 'returns a JSON response with the new term' do
        post :create, params: valid_params
        expect(response).to have_http_status(:ok)
        term = JSON.parse(response.body)
        expect(term['source_text']).to eq(valid_params[:source_term])
        expect(term['target_text']).to eq(valid_params[:target_term])
      end
    end

    context 'with missing params' do
      it 'returns a 400 Bad Request response' do
        post :create, params: missing_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        post :create, params: missing_params
        error = JSON.parse(response.body)
        expect(error['message']).to eq('Required params are missing')
      end
    end

    context 'with invalid params' do
      it 'returns a 422 Unprocessable Entity response' do
        post :create, params: invalid_params
        term = JSON.parse(response.body)
        expect(term['message']).to eq(["Source text can't be blank",
                                       'Source text is too short (minimum is 2 characters)',
                                       "Target text can't be blank",
                                       'Target text is too short (minimum is 2 characters)'])
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
