# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    return unless link.linkable&.author_id == current_user&.id

    link.destroy
  end

  private

  def link
    @link ||= params[:id] ? Link.find(params[:id]) : Link.new
  end
end
