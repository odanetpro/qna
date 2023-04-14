# frozen_string_literal: true

require 'rails_helper'

feature "Author can delete attached file from his own question, but can't delete from someone else's", "
  In order to correct mistake
  As an authenticated user
  I'd like to be able to delete attached file only for my own questions
" do
  given!(:user) { create(:user) }
  given(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')) }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }

    scenario 'deletes attached file from his question' do
      question = create(:question, author: user)
      question.files.attach(file)

      visit question_path(question)

      within '.question' do
        expect(page).to have_content 'rails_helper.rb'

        accept_confirm do
          find('a.remove-file').click
        end

        expect(page).to_not have_content 'rails_helper.rb'
      end
    end

    scenario "tries to delete attached file from some one else's question" do
      someone_else_question = create(:question)
      someone_else_question.files.attach(file)

      visit question_path(someone_else_question)

      within '.question' do
        expect(page).to_not have_css 'a.remove-file'
      end
    end
  end

  scenario 'Unauthenticated user can not delete attached file', js: true do
    question = create(:question, author: user)
    question.files.attach(file)

    visit question_path(question)

    within '.question' do
      expect(page).to_not have_css 'a.remove-file'
    end
  end
end
