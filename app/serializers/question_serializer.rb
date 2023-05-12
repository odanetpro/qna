# frozen_string_literal: true

class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :body, :links, :comments, :author_id, :created_at, :updated_at, :files_urls

  def files_urls
    object.files.map { |file| rails_blob_path(file, only_path: true) }
  end
end
