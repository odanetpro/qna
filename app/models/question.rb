# frozen_string_literal: true

class Question < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_one :award, dependent: :destroy

  has_many_attached :files

  belongs_to :author, class_name: 'User'
  belongs_to :best_answer, class_name: 'Answer', optional: true

  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, :body, presence: true

  def reset_best_answer
    self.best_answer = nil
    save!
  end

  def other_answers
    answers.where.not(id: best_answer_id)
  end
end
