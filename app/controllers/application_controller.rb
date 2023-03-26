# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def best_answer
    question.best_answer_id ? Answer.with_attached_files.find(question.best_answer_id) : nil
  end

  def other_answers
    question.other_answers.with_attached_files
  end

  helper_method :best_answer, :other_answers
end
