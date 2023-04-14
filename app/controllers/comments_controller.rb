# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: :create

  def create
    @comment = commentable.comments.create(comment_params)
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(author_id: current_user.id)
  end

  def commentable_model_klass
    @commentable_model_klass ||= params[:comment][:commentable_type].constantize
  end

  def commentable
    @commentable ||= commentable_model_klass.find(params["#{commentable_model_klass.name.underscore}_id"])
  end

  def publish_comment
    return if @comment.errors.any?

    question_id = commentable.is_a?(Question) ? commentable.id : commentable.question.id

    ActionCable.server.broadcast(
      "comments_for_question_#{question_id}_and_for_its_answers",
      ApplicationController.render(json: { comment: @comment })
    )
  end
end
