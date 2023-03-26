# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  has_one_attached :file

  belongs_to :author, class_name: 'User'
  belongs_to :best_answer, class_name: 'Answer', optional: true

  validates :title, :body, presence: true

  def reset_best_answer
    self.best_answer = nil
    save!
  end

  def other_answers
    answers.where.not(id: best_answer_id)
  end
end
