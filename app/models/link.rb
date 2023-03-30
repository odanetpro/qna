# frozen_string_literal: true

class Link < ApplicationRecord
  URL_REGEXP = %r{\A(http|https)://[a-z0-9]+([\-.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?/.*)?\z}ix

  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, presence: true, format: { with: URL_REGEXP }

  def gist?
    url.include?('gist.github.com')
  end
end
