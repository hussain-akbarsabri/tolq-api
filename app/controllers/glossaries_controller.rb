# frozen_string_literal: true

class GlossariesController < ApplicationController
  before_action :find_glossary, only: [:show]

  def create
    unless params[:source_language_code].present? && params[:target_language_code].present?
      return missing_params_response
    end

    save_record(Glossary.new(glossary_params))
  end

  def show
    json_response(@glossary)
  end

  def index
    json_response(Glossary.all)
  end

  private

  def language_code(language_code)
    LanguageCode.find_by(code: language_code)
  end

  def find_glossary
    @glossary = Glossary.find(params[:id])
  end

  def glossary_params
    { source_language_code_id: language_code(params[:source_language_code])&.id,
      target_language_code_id: language_code(params[:target_language_code])&.id }
  end
end
