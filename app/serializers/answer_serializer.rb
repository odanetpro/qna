# frozen_string_literal: true

class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :body, :author_id, :question_id, :created_at, :updated_at, :comments, :links, :files_urls

  def files_urls
    object.files.map { |file| rails_blob_path(file, only_path: true) }
  end
end
