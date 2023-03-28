# frozen_string_literal: true

class Answer < ApplicationRecord
  has_many :links, dependent: :destroy, as: :linkable

  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  before_destroy :before_destroy_check_best_answer

  def mark_as_best
    question.update(best_answer_id: id)
  end

  private

  def before_destroy_check_best_answer
    question.reset_best_answer if question.best_answer == self
  end
end
