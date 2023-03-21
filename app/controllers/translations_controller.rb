# frozen_string_literal: true

class TranslationsController < ApplicationController
  before_action :find_translation, only: [:show]
  before_action :find_glossary, only: [:create]

  def create
    unless params[:source_language_code].present? && params[:target_language_code].present? && params[:source_text].present?
      return missing_params_response
    end

    save_record(Translation.new(translation_params))
  end

  def show
    if @translation.glossary.present?
      @translation.glossary.terms.pluck(:source_text).uniq.map do |text|
        @translation.source_text.gsub!(text, "<HIGHLIGHT>#{text}</HIGHLIGHT>") if @translation.source_text.include?(text)
      end
    end
    json_response(@translation)
  end

  private

  def language_code(language_code)
    LanguageCode.find_by(code: language_code)
  end

  def find_translation
    @translation = Translation.find(params[:id])
  end

  def find_glossary
    @glossary = Glossary.find_by(id: params[:glossary_id])
  end

  def translation_params
    { source_language_code_id: language_code(params[:source_language_code])&.id,
      target_language_code_id: language_code(params[:target_language_code])&.id,
      glossary_id: @glossary&.id, source_text: params[:source_text] }
  end
end
