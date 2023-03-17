# frozen_string_literal: true

require 'rails_helper'

feature 'Author can choose the best answer for his question', "
  In order to help other users find the best solution
  As an author of question
  I'd like to be able to choose only one best answer for my question
" do
  given!(:user) { create(:user) }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }

    scenario 'choose the best answer for his question' do
      question = create(:question, author: user)
      answer = create(:answer, question: question)

      visit question_path(question)

      within ".answer-#{answer.id}" do
        click_on 'Best'
      end

      expect(page).to have_css '.best-answer'
    end

    scenario "tries to choose the best answer for someone else's question" do
      question = create(:question)
      answer = create(:answer, question: question)

      visit question_path(question)

      within ".answer-#{answer.id}" do
        expect(page).to_not have_content 'Edit'

        post(mark_best_answer_path(answer))
        expect(page).to_not have_css '.best-answer'
      end
    end
  end

  scenario 'Unauthenticated user can not choose the best answer', js: true do
    question = create(:question)
    answer = create(:answer, question: question)

    visit question_path(question)

    within ".answer-#{answer.id}" do
      expect(page).to_not have_content 'Edit'

      post(mark_best_answer_path(answer))
      expect(page).to_not have_css '.best-answer'
    end
  end
end
