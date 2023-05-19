# frozen_string_literal: true

class QuestionSubscriptionsController < ApplicationController
  before_action :question, only: %i[create]

  authorize_resource

  def create
    @question.subscribers << current_user unless current_user.subscribed_for_question?(@question)
  end

  private

  def question
    @question ||= Question.find(params[:id])
  end
end
