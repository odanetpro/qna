# frozen_string_literal: true

module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, dependent: :destroy, as: :commentable
    accepts_nested_attributes_for :comments, reject_if: :all_blank
  end
end
