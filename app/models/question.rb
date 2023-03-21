# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  has_many_attached :files

  belongs_to :author, class_name: 'User'
  belongs_to :best_answer, class_name: 'Answer', optional: true

  validates :title, :body, presence: true

  def reset_best_answer
    self.best_answer = nil
    save!
  end

  def best_answer
    best_answer_id ? Answer.with_attached_files.find(best_answer_id) : nil
  end

  def answers
    Answer.with_attached_files.where(question_id: id)
  end

  def other_answers
    answers.where.not(id: best_answer_id)
  end
end
