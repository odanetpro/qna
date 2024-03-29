# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for answer', "
  In order to determine the best answer according to users
  As an authenticated user
  I'd like to be able to add vote (for or against) to answer
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'vote for answer' do
      within "#answer-rating-#{answer.id}" do
        find('.vote-up').click
        find('.rating-value').has_content?('1')
      end
    end

    scenario 'vote against answer' do
      within "#answer-rating-#{answer.id}" do
        find('.vote-down').click
        find('.rating-value').has_content?('-1')
      end
    end

    scenario 'vote for best answer' do
      answer.mark_as_best
      within "#answer-rating-#{answer.id}" do
        find('.vote-up').click
        find('.rating-value').has_content?('1')
      end
    end

    scenario 'vote against bets answer' do
      answer.mark_as_best
      within "#answer-rating-#{answer.id}" do
        find('.vote-down').click
        find('.rating-value').has_content?('-1')
      end
    end

    scenario 'author tries to vote for his answer' do
      his_answer = create(:answer, question: question, author: user)
      visit question_path(question)

      within "#answer-rating-#{his_answer.id}" do
        expect(page).to_not have_css('.vote-up')
        expect(page).to_not have_css('.vote-down')
        find('.rating-value').has_content?('0')
      end
    end

    scenario 'author tries to vote for his best answer' do
      his_answer = create(:answer, question: question, author: user)
      his_answer.mark_as_best
      visit question_path(question)

      within "#answer-rating-#{his_answer.id}" do
        expect(page).to_not have_css('.vote-up')
        expect(page).to_not have_css('.vote-down')
        find('.rating-value').has_content?('0')
      end
    end
  end

  scenario 'Unauthenticated user tries to vote for answer' do
    visit question_path(question)

    within "#answer-rating-#{answer.id}" do
      expect(page).to_not have_css('.vote-up')
      expect(page).to_not have_css('.vote-down')
    end
  end
end
