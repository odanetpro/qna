# frozen_string_literal: true

require 'rails_helper'

feature 'User can create an answer to the question', "
  In order to help other users find a solution to the problem
  As an authenticated user
  I'd like to be able to answer the question on the question page
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers the question' do
      fill_in 'answer[body]', with: 'Test answer'
      click_button 'Post Your Answer'

      expect(page).to have_content 'Your answer successfully created!'
      expect(page).to have_content question.title
      expect(page).to have_content 'Test answer'
    end

    scenario 'answers the question with errors' do
      click_button 'Post Your Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries answer the question' do
    visit question_path(question)
    click_button 'Post Your Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
