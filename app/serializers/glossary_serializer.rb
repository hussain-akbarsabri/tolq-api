# frozen_string_literal: true

class GlossarySerializer < ActiveModel::Serializer
  attributes :id, :source_language_code_id, :target_language_code_id
  has_many :terms
end
