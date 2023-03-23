# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his answers', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }

    scenario 'edits his answer' do
      answer = create(:answer, question: question, author: user)

      visit question_path(question)
      click_on 'Edit'

      within '.answers' do
        fill_in 'answer[body]', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      create(:answer, question: question, author: user)

      visit question_path(question)
      click_on 'Edit'

      within '.answers' do
        fill_in 'answer[body]', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's answer" do
      someone_else_answer = create(:answer, question: question, author: create(:user))

      visit question_path(question)

      within ".answer-#{someone_else_answer.id}" do
        expect(page).to_not have_content 'Edit'

        page.execute_script("$('form#edit-answer-#{someone_else_answer.id}').removeClass('hidden')")
        fill_in 'answer[body]', with: 'new answer body'
        click_on 'Save'
      end

      expect(page).to_not have_content 'new answer body'
    end

    scenario 'adds files when editing answer' do
      file1 = Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb'))
      file2 = Rack::Test::UploadedFile.new(Rails.root.join('spec/spec_helper.rb'))
      answer = create(:answer, question: question, author: user)
      answer.files.attach([file1, file2])

      visit question_path(question)

      within ".answer-#{answer.id}" do
        click_on 'Edit'
        attach_file 'answer[files][]', Rails.root.join('spec/factories/questions.rb')
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to have_link 'questions.rb'
      end
    end
  end

  scenario 'Unauthenticated user can not edit answer', js: true do
    answer = create(:answer, question: question, author: user)

    visit question_path(question)

    expect(page).to_not have_link 'Edit'

    within '.answers' do
      page.execute_script("$('form#edit-answer-#{answer.id}').removeClass('hidden')")
      fill_in 'answer[body]', with: 'new answer body'
      click_on 'Save'

      expect(page).to_not have_content 'new answer body'
    end
  end
end
