# frozen_string_literal: true

class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :body, :author_id, :question_id, :created_at, :updated_at
end
