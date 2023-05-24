# frozen_string_literal: true

class SearchesController < ApplicationController
  authorize_resource class: false

  def search
    @search_results = model_klass.search(Riddle.escape(params[:search_query]))
    render :search_result
  end

  private

  def model_klass
    return ThinkingSphinx if params[:search_scope] == 'all'

    @model_klass ||= params[:search_scope].classify.constantize
  end
end
