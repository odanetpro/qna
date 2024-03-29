# frozen_string_literal: true

class Award < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  has_one_attached :image

  validates :name, :image, presence: true
end
