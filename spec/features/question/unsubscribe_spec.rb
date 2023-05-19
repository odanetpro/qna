# frozen_string_literal: true

require 'rails_helper'

feature 'User can unsubscribe from question updates', "
  In order to cancel subscription
  As subscribed user
  I'd like to be able to not receive email when a new answer to question is created
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      question.subscribers << user
    end

    scenario 'subscriber unsubscribe from question', js: true do
      sign_in(user)
      visit question_path(question)

      find('.unsubscribe-question-link').click

      expect(page).to have_css('.subscribe-question-link')
      expect(page).to_not have_css('.unsubscribe-question-link')
      expect(page).to have_content(I18n.t('question_subscriptions.destroy.success'))
    end

    scenario 'not subscriber tries to unsubscribe from question' do
      sign_in(create(:user))
      visit question_path(question)

      expect(page).to_not have_css('.unsubscribe-question-link')
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to unsubscribe' do
      visit question_path(question)

      expect(page).to_not have_css('.unsubscribe-question-link')
    end
  end
end
