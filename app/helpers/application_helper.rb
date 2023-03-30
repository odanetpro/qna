# frozen_string_literal: true

module ApplicationHelper
  def gist_id(url)
    url.split('/').last
  end
end
