# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his questions', "
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit only my own questions
" do
  given!(:user) { create(:user) }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }

    scenario 'edits his question' do
      question = create(:question, author: user)

      visit question_path(question)

      within '.question' do
        click_on 'Edit'

        fill_in 'question[title]', with: 'new question title'
        fill_in 'question[body]', with: 'new question body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'new question title'
        expect(page).to have_content 'new question body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      question = create(:question, author: user)

      visit question_path(question)

      within '.question' do
        click_on 'Edit'

        fill_in 'question[title]', with: ''
        fill_in 'question[body]', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question" do
      someone_else_question = create(:question, author: create(:user))

      visit question_path(someone_else_question)

      within '.question' do
        expect(page).to_not have_content 'Edit'

        page.execute_script("$('form#edit-question').removeClass('hidden')")
        fill_in 'question[title]', with: 'new question title'
        fill_in 'question[body]', with: 'new question body'
        click_on 'Save'
      end

      expect(page).to have_content "No rights to edit someone else's question."
      expect(page).to_not have_content 'new question title'
      expect(page).to_not have_content 'new question body'
    end
  end

  scenario 'Unauthenticated user can not edit question', js: true do
    question = create(:question, author: user)

    visit question_path(question)

    within '.question' do
      expect(page).to_not have_content 'Edit'

      page.execute_script("$('form#edit-question').removeClass('hidden')")
      fill_in 'question[title]', with: 'new question title'
      fill_in 'question[body]', with: 'new question body'
      click_on 'Save'

      expect(page).to_not have_content 'new question title'
      expect(page).to_not have_content 'new question body'
    end
  end
end
