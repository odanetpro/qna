# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    @answer = question.answers.build
    @answer.links.build
  end

  def new
    question.links.build
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    return unless question.author_id == current_user&.id

    question.files.attach(question_params['files']) if question_params['files']
    question.update(question_params.except(:files))
  end

  def destroy
    return unless question.author_id == current_user&.id

    question.destroy
    redirect_to questions_path, notice: 'Your question deleted.'
  end

  def delete_file
    return unless question.author_id == current_user&.id

    @attached_file = question.files.find_by(id: params[:file_id])
    @attached_file.purge
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                                    links_attributes: %i[id name url]).merge(author_id: current_user.id)
  end
end
