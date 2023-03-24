# frozen_string_literal: true

require 'rails_helper'

feature "Author can delete attached file from his own answer, but can't delete from someone else's", "
  In order to correct mistake
  As an authenticated user
  I'd like to be able to delete attached file only for my own answers
" do
  given!(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')) }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }

    scenario 'deletes attached file from his answer' do
      answer = create(:answer, question: question, author: user)
      answer.files.attach(file)

      visit question_path(question)

      within ".answer-#{answer.id}" do
        expect(page).to have_content 'rails_helper.rb'

        accept_confirm do
          click_on 'Remove'
        end

        expect(page).to_not have_content 'rails_helper.rb'
      end
    end

    scenario 'deletes attached file from his best answer' do
      answer = create(:answer, question: question, author: user)
      answer.mark_as_best
      answer.files.attach(file)

      visit question_path(question)

      within ".answer-#{answer.id}" do
        expect(page).to have_content 'rails_helper.rb'

        accept_confirm do
          click_on 'Remove'
        end

        expect(page).to_not have_content 'rails_helper.rb'
      end
    end

    scenario "tries to delete attached file from some one else's answer" do
      someone_else_answer = create(:answer, question: question)
      someone_else_answer.files.attach(file)

      visit question_path(question)

      within ".answer-#{someone_else_answer.id}" do
        expect(page).to_not have_content 'Remove'
      end
    end
  end

  scenario 'Unauthenticated user can not delete attached file', js: true do
    answer = create(:answer, question: question, author: user)
    answer.files.attach(file)

    visit question_path(question)

    within ".answer-#{answer.id}" do
      expect(page).to_not have_content 'Remove'
    end
  end
end
