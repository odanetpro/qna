# frozen_string_literal: true

require 'rails_helper'

feature 'User can add comment to answer', "
  In order to provide some remark to answer
  As an authenticated user
  I'd like to be able to add comments to answer
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    before { sign_in(user) }

    scenario 'adds new comment to answer' do
      answer = create(:answer, question: question)
      visit question_path(question)

      within ".answer-#{answer.id}" do
        click_on 'Add a comment'
        expect(page).to_not have_link 'Add a comment'

        fill_in 'comment[body]', with: 'new comment'
        click_on 'Post your comment'

        expect(page).to have_content 'new comment'
        expect(page).to have_link 'Add a comment'
      end
    end

    scenario 'adds new comment to best answer' do
      answer = create(:answer, question: question)
      answer.mark_as_best
      visit question_path(question)

      within ".answer-#{answer.id}" do
        click_on 'Add a comment'
        expect(page).to_not have_link 'Add a comment'

        fill_in 'comment[body]', with: 'new comment'
        click_on 'Post your comment'

        expect(page).to have_content 'new comment'
        expect(page).to have_link 'Add a comment'
      end
    end

    scenario 'adds new comment to answer with errors' do
      answer = create(:answer, question: question)
      visit question_path(question)

      within ".answer-#{answer.id}" do
        click_on 'Add a comment'
        click_on 'Post your comment'

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'adds new comment to best answer with errors' do
      answer = create(:answer, question: question)
      answer.mark_as_best
      visit question_path(question)

      within ".answer-#{answer.id}" do
        click_on 'Add a comment'
        click_on 'Post your comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Unauthenticated user tries to add comment to answer' do
    answer = create(:answer, question: question)
    visit question_path(question)

    within ".answer-#{answer.id}" do
      expect(page).to_not have_link 'Add a comment'
    end
  end
end
