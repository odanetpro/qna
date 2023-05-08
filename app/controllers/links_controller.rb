# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :link, only: :destroy

  authorize_resource

  def destroy
    link.destroy
  end

  private

  def link
    @link ||= params[:id] ? Link.find(params[:id]) : Link.new
  end
end
