# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As a question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/odanetpro/fd69fb3ff2341345606b8fb05d05eb68' }

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'answer[body]', with: 'Test answer'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_button 'Post Your Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end