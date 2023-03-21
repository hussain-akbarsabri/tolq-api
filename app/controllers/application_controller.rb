# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render404

  def save_record(record)
    if record.save
      json_response(record)
    else
      error_response(record.errors.full_messages)
    end
  end

  def render404
    render json: { message: 'Record not found' }, status: :not_found
  end

  def json_response(record)
    render json: record, status: :ok
  end

  def error_response(error_message)
    render json: { message: error_message }, status: :bad_request
  end

  def missing_params_response
    render json: { message: 'Required params are missing' }, status: :unprocessable_entity
  end
end
