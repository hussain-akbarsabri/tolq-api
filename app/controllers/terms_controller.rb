# frozen_string_literal: true

class TermsController < ApplicationController
  before_action :find_glossary, only: [:create]

  def create
    return missing_params_response unless params[:source_term] && params[:target_term]

    save_record(@glossary.terms.new(term_params))
  end

  private

  def find_glossary
    @glossary = Glossary.find(params[:glossary_id])
  end

  def term_params
    { source_text: params[:source_term], target_text: params[:target_term] }
  end
end
