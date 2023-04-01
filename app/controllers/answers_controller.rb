# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.create(answer_params)
  end

  def update
    return unless answer.author_id == current_user&.id

    answer.files.attach(answer_params['files']) if answer_params['files']
    answer.update(answer_params.except(:files))
  end

  def destroy
    return unless answer.author_id == current_user&.id

    answer.destroy
  end

  def mark_best
    return unless answer.question.author_id == current_user&.id

    answer.mark_as_best
  end

  def delete_file
    return unless answer.author_id == current_user&.id

    @attached_file = answer.files.find_by(id: params[:file_id])
    @attached_file.purge
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                          links_attributes: %i[id name url]).merge(author_id: current_user.id)
  end

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : question.answers.build
  end

  helper_method :answer, :question
end
