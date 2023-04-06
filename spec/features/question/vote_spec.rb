# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for question', "
  In order to determine the rating of the question
  As an authenticated user
  I'd like to be able to add vote (for or against) to question
" do
  given(:user) { create(:user) }

  describe 'Authenticated user', js: true do
    given!(:question) { create(:question) }

    background do
      sign_in(user)
    end

    describe 'not author' do
      background do
        visit question_path(question)
      end

      scenario 'vote for question' do
        within '.question-rating' do
          find('.vote-up').click
          find('.rating-value').has_content?('1')
        end
      end

      scenario 'vote against question' do
        within '.question-rating' do
          find('.vote-down').click
          find('.rating-value').has_content?('-1')
        end
      end
    end

    scenario 'author tries to vote for his question' do
      question = create(:question, author: user)
      visit question_path(question)

      within '.question-rating' do
        expect(page).to_not have_css('.vote-up')
        expect(page).to_not have_css('.vote-down')
        find('.rating-value').has_content?('0')
      end
    end
  end

  scenario 'Unauthenticated user tries to vote for question' do
    visit question_path(create(:question))

    within '.question-rating' do
      expect(page).to_not have_css('.vote-up')
      expect(page).to_not have_css('.vote-down')
      find('.rating-value').has_content?('0')
    end
  end
end
