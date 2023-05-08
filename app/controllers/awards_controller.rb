# frozen_string_literal: true

class AwardsController < ApplicationController
  before_action :authenticate_user!, only: :user_awards
  before_action :set_user, only: :user_awards

  authorize_resource

  def user_awards
    @awards = @user.awards
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
