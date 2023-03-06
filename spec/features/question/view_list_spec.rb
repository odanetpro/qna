# frozen_string_literal: true

require 'rails_helper'

feature 'User can view the list of questions', "
  In order to find a solution to the problem
  As any user (authenticated or not)
  I would like to be able to see the questions that users have asked
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    scenario 'tries to view the list of questions' do
      sign_in(user)

      visit questions_path
      expect(page).to have_content 'All Questions'
      expect(page).to have_content question.title
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to view the list of questions' do
      visit questions_path
      expect(page).to have_content 'All Questions'
      expect(page).to have_content question.title
    end
  end
end
