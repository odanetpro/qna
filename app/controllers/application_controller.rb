# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  private

  def gon_user
    gon.user_id = current_user&.id
  end

  def best_answer
    question.best_answer_id ? Answer.with_attached_files.find(question.best_answer_id) : nil
  end

  def other_answers
    question.other_answers.with_attached_files
  end

  helper_method :best_answer, :other_answers
end
