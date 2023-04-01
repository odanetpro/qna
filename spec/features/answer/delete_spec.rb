# frozen_string_literal: true

require 'rails_helper'

feature "Author can delete his own answer, but can't delete someone else's answer", "
  In order to remove answer from the list of answers
  As an authenticated user
  I'd like to be able to delete only my own answers
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
    end

    scenario 'tries to delete his own answer' do
      answer = create(:answer, question: question, author: user)

      visit question_path(question)
      accept_confirm do
        click_on 'Delete'
      end

      expect(page).to have_content 'Your answer deleted.'
      expect(page).to_not have_content answer.body
    end

    scenario 'tries to delete his own best answer' do
      answer = create(:answer, question: question, author: user)
      answer.mark_as_best

      visit question_path(question)
      accept_confirm do
        click_on 'Delete'
      end

      expect(page).to have_content 'Your answer deleted.'
      expect(page).to_not have_content answer.body
    end

    scenario "tries to delete someone else's answer" do
      create(:answer, question: question, author: create(:user))

      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_content 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user tries to delete the answer', js: true do
    answer = create(:answer, question: question, author: user)

    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_content 'Delete'
      delete(answer_path(answer))
      expect(page).to have_content answer.body
    end
  end
end
