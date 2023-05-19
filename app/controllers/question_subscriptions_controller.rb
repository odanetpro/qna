# frozen_string_literal: true

class QuestionSubscriptionsController < ApplicationController
  before_action :question, only: %i[create destroy]

  authorize_resource

  def create
    return if current_user.subscribed_for_question?(@question)

    @question.subscribers << current_user
  end

  def destroy
    return unless current_user.subscribed_for_question?(@question)

    @subscription = current_user.question_subscriptions.find_by(question_id: @question.id)
    @subscription.destroy
  end

  private

  def question
    @question ||= Question.find(params[:id])
  end
end
