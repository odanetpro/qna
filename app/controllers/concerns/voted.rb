# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_vote, only: %i[vote_up vote_down]
    before_action :set_voted, only: %i[vote_up vote_down]
    helper_method :rating
  end

  def vote_up
    if @voted.author_id == current_user.id || @vote.like?
      render json: {}, status: :not_acceptable
    else
      # set_like works for new vote
      @vote.dislike? ? @vote.destroy : @vote.set_like
      render json: { rating: rating(@voted), id: @voted.id }, status: :ok
    end
  end

  def vote_down
    if @voted.author_id == current_user.id || @vote.dislike?
      render json: {}, status: :not_acceptable
    else
      # set_dislike works for new vote
      @vote.like? ? @vote.destroy : @vote.set_dislike
      render json: { rating: rating(@voted), id: @voted.id }, status: :ok
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

  def rating(voted)
    voted.votes.sum(:value)
  end
end
