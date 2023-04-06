# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_vote, only: %i[vote_up vote_down]
    before_action :set_voted, only: %i[vote_up vote_down]
  end

  def vote_up
    return if @voted.author_id == current_user.id || @vote.like?

    if @vote.dislike?
      @vote.destroy
      return
    end

    @vote.set_like!

    respond_to do |format|
      format.json { render json: {}, status: :ok }
    end
  end

  def vote_down
    return if @voted.author_id == current_user.id || @vote.dislike?

    if @vote.like?
      @vote.destroy
      return
    end

    @vote.set_dislike!

    respond_to do |format|
      format.json { render json: {}, status: :ok }
    end
  end

  private

  def model_klass
    @model_klass ||= controller_name.classify.constantize
  end

  def set_vote
    @vote = Vote.find_by(vote_params) || Vote.new(vote_params)
  end

  def vote_params
    { user: current_user, votable_type: model_klass.to_s, votable_id: params[:id] }
  end

  def set_voted
    @voted = model_klass.find(params[:id])
  end
end
