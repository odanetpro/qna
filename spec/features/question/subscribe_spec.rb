# frozen_string_literal: true

require 'rails_helper'

feature 'User can subscribe to question updates', "
  In order to quickly find out about updates
  As authenticated user
  I'd like to be able to receive email when a new answer to question is created
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'subscribe', js: true do
      visit question_path(question)
      expect(page).to have_css('.subscribe-question-link')

      find('.subscribe-question-link').click

      expect(page).to_not have_css('.subscribe-question-link')
      expect(page).to have_content(I18n.t('question_subscriptions.create.success'))
    end

    scenario 'tries to subscribe one more time to the same question' do
      question.subscribers << user
      visit question_path(question)

      expect(page).to_not have_css('.subscribe-question-link')
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to subscribe' do
      visit question_path(question)

      expect(page).to_not have_css('.subscribe-question-link')
    end
  end
end
