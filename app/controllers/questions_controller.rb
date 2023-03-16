# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    @answer = question.answers.build
  end

  def new; end

  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if question.author_id == current_user&.id
      question.update(question_params)
    else
      redirect_to question, alert: "No rights to edit someone else's question.", format: 'js'
    end
  end

  def destroy
    if question.author_id == current_user&.id
      question.destroy
      redirect_to questions_path, notice: 'Your question deleted.'
    else
      redirect_to questions_path, alert: "No rights to delete someone else's question."
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body).merge(author_id: current_user.id)
  end
end
