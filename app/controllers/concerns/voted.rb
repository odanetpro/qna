# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_vote, only: %i[vote_up vote_down]
  end

  def vote_up
    @vote.set_like!

    respond_to do |format|
      format.json { render json: {}, status: :ok }
    end
  end

  def vote_down
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
end
