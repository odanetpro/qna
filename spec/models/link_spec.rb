# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it 'should validate URL' do
    correct_urls = %w[http://ruby3arabi.com
                      http://www.ruby3arabi.com
                      https://www.ruby3arabi.com
                      https://www.ruby3arabi.com/article/1
                      https://www.ruby3arabi.com/websites/58e212ff6d275e4bf9000000?locale=en]

    wrong_urls = %w[http://ruby3arabi
                    http://http://ruby3arabi.com
                    http://
                    http://test.com\n<script src=\"nasty.js\">
                    127.0.0.1]

    correct_urls.each do |url|
      should allow_values(url).for(:url)
    end

    wrong_urls.each do |url|
      should_not allow_values(url).for(:url)
    end
  end

  it 'should define a gist link' do
    question = create(:question)

    link = create(:link, url: 'http://yandex.ru', linkable: question)
    gist_link = create(:link, url: 'https://gist.github.com/odanetpro/fd69fb3ff2341345606b8fb05d05eb68',
                              linkable: question)

    expect(gist_link.gist?).to be_truthy
    expect(link.gist?).to be_falsey
  end
end
