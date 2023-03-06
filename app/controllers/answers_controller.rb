# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def create
    @answer = question.answers.build(answer_params)

    if @answer.save
      redirect_to question, notice: 'Your answer successfully created!'
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.build
  end

  helper_method :answer, :question
end
