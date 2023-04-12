# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = commentable.comments.build(comment_params)
    @comment.save
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
end
