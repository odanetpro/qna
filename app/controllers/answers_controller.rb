# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def create
    @answer = question.answers.create(answer_params)
  end

  def destroy
    if answer.author_id == current_user&.id
      answer.destroy
      redirect_to answer.question, notice: 'Your answer deleted.'
    else
      redirect_to answer.question, alert: "No rights to delete someone else's answer."
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body).merge(author_id: current_user.id)
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.build
  end

  helper_method :answer, :question
end
