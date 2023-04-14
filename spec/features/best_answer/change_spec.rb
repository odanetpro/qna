# frozen_string_literal: true

require 'rails_helper'

feature 'Author of question can choose another best answer if the question already has a best one', "
  In order to choose a better answer
  As an author of question
  I'd like to be able to choose another best answer for my question
" do
  given!(:user) { create(:user) }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }

    scenario 'choose another best answer for his question' do
      question = create(:question, author: user)
      answer1 = create(:answer, question: question)
      answer2 = create(:answer, question: question)
      answer1.mark_as_best

      visit question_path(question)

      within ".answer-#{answer2.id}" do
        find('.best-answer-link').click
      end

      within '.best-answer' do
        expect(page).to have_content answer2.body
        expect(page).to_not have_content answer1.body
      end
    end

    scenario "tries to choose another best answer for someone else's question" do
      question = create(:question)
      answer1 = create(:answer, question: question)
      answer2 = create(:answer, question: question)
      answer1.mark_as_best

      visit question_path(question)

      within ".answer-#{answer2.id}" do
        expect(page).to_not have_content 'Best'
        post(mark_best_answer_path(answer2))
      end

      within '.best-answer' do
        expect(page).to have_content answer1.body
        expect(page).to_not have_content answer2.body
      end
    end
  end

  scenario 'Unauthenticated user can not choose another best answer', js: true do
    question = create(:question)
    answer1 = create(:answer, question: question)
    answer2 = create(:answer, question: question)
    answer1.mark_as_best

    visit question_path(question)

    within ".answer-#{answer2.id}" do
      expect(page).to_not have_content 'Best'
      post(mark_best_answer_path(answer2))
    end

    within '.best-answer' do
      expect(page).to have_content answer1.body
      expect(page).to_not have_content answer2.body
    end
  end
end
