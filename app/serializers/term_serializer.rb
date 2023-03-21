# frozen_string_literal: true

class TermSerializer < ActiveModel::Serializer
  attributes :id, :source_text, :target_text, :glossary_id
end
