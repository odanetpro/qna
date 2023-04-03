# frozen_string_literal: true

class AwardsController < ApplicationController
  before_action :authenticate_user!, only: :user_awards

  def user_awards
    @user = User.find(params[:user_id])

    if @user.id == current_user&.id
      @awards = @user.awards
    else
      redirect_to root_path, alert: "You don't have permission to view this user's awards"
    end
  end
end
