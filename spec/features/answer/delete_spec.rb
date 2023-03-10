# frozen_string_literal: true

require 'rails_helper'

feature "Author can delete his own answer, but can't delete someone else's answer", "
  In order to remove answer from the list of answers
  As an authenticated user
  I'd like to be able to delete only my own answers
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'tries to delete his own answer' do
      create(:answer, question: question, author: user)

      visit question_path(question)
      click_on 'Delete'

      expect(page).to have_content 'Your answer deleted.'
    end

    scenario "tries to delete someone else's answer" do
      someone_else_answer = create(:answer, question: question, author: create(:user))

      visit question_path(question)
      page.driver.submit :delete, answer_path(someone_else_answer), {}

      expect(page).to have_content "No rights to delete someone else's answer."
    end
  end

  scenario 'Unauthenticated user tries to delete the answer' do
    answer = create(:answer, question: question, author: user)

    visit question_path(question)
    page.driver.submit :delete, answer_path(answer), {}

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
