# frozen_string_literal: true

class SearchesController < ApplicationController
  authorize_resource class: false

  def search
    @search_results = model_klass.search(params[:search_query])
    render :search_result
  end

  private

  def model_klass
    @model_klass ||= params[:search_scope].classify.constantize
  end
end
