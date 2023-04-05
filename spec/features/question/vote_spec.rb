# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for question', "
  In order to determine the rating of the question
  As an authenticated user
  I'd like to be able to add vote (for or against) to question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'vote for question' do
      within '.question-rating' do
        find('.vote-up').click
      end
    end

    scenario 'vote against question' do
      within '.question-rating' do
        find('.vote-down').click
      end
    end
  end

  scenario 'Unauthenticated user tries to vote for question' do
    visit question_path(question)

    within '.question-rating' do
      expect(page).to_not have_css('.vote-up')
      expect(page).to_not have_css('.vote-down')
    end
  end
end
