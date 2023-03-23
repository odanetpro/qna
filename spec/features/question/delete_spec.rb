# frozen_string_literal: true

require 'rails_helper'

feature "Author can delete his own question, but can't delete someone else's question", "
  In order to remove question from the list of questions
  As an authenticated user
  I'd like to be able to delete only my own questions
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'tries to delete his own question' do
      visit question_path(question)
      within '.question' do
        click_on 'Delete'
      end

      expect(page).to have_content 'Your question deleted.'
    end

    scenario "tries to delete someone else's question" do
      someone_else_question = create(:question, author: create(:user))

      visit question_path(someone_else_question)

      within '.question' do
        expect(page).to_not have_content 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user tries to delete the question' do
    visit question_path(question)
    page.driver.submit :delete, question_path(question), {}

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
