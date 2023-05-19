# frozen_string_literal: true

class Question < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :question_subscriptions, dependent: :destroy
  has_many :subscribers, through: :question_subscriptions, source: :user
  has_one :award, dependent: :destroy

  has_many_attached :files

  belongs_to :author, class_name: 'User'
  belongs_to :best_answer, class_name: 'Answer', optional: true

  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, :body, presence: true

  scope :for_last_day, -> { where(created_at: 1.day.ago..Time.current) }

  def reset_best_answer
    self.best_answer = nil
    save!
  end

  def other_answers
    answers.where.not(id: best_answer_id)
  end
end
