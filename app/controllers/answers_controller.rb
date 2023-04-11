# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  after_action :publish_answer, only: :create

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

    question.award&.update(user_id: answer.author.id)
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

  def publish_answer
    return if answer.errors.any?

    ActionCable.server.broadcast(
      "answers_for_question_#{question.id}",
      ApplicationController.render(json: { question: question, answer: answer, answer_files: answer_files,
                                           answer_links: answer_links, answer_vote: answer_vote,
                                           answer_controls: answer_controls }.to_json)
    )
  end

  def answer_files
    answer.files.map { |file| { id: file.id, name: file.filename, url: url_for(file) } }
  end

  def answer_links
    answer.links.map do |link|
      if link.gist?
        { id: link.id, name: link.name, url: link.url, gist_id: helpers.gist_id(link.url) }
      else
        { id: link.id, name: link.name, url: link.url }
      end
    end
  end

  def answer_vote
    {
      rating: rating(answer),
      up_path: polymorphic_path([:vote_up, answer]),
      down_path: polymorphic_path([:vote_down, answer])
    }
  end

  def answer_controls
    { mark_best_path: mark_best_answer_path(answer) }
  end
end
