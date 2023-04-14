# frozen_string_literal: true

require 'rails_helper'

feature 'User can create an answer to the question', "
  In order to help other users find a solution to the problem
  As an authenticated user
  I'd like to be able to answer the question on the question page
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers the question' do
      fill_in 'answer[body]', with: 'Test answer'
      click_button 'Post Your Answer'

      sleep 3

      expect(current_path).to eq question_path(question)

      expect(page).to have_content 'Your answer successfully created!'
      expect(page).to have_content question.title

      within '.answers' do
        expect(page).to have_content 'Test answer'
      end
    end

    scenario 'answers the question with errors' do
      click_button 'Post Your Answer'

      within '.answer-errors-new' do
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'answers the question with attached files' do
      fill_in 'answer[body]', with: 'Test answer'
      attach_file 'answer[files][]', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]
      click_button 'Post Your Answer'

      sleep 2

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'multiple sessions', js: true do
    given(:google_url) { 'http://google.com' }

    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'answer[body]', with: 'Test answer'
        attach_file 'answer[files][]', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: google_url
        click_button 'Post Your Answer'

        expect(current_path).to eq question_path(question)
        expect(page).to have_content question.title

        within '.answers' do
          expect(page).to have_content 'Test answer'
          expect(page).to have_link 'Google', href: google_url
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'Test answer'
          expect(page).to have_link 'Google', href: google_url
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    scenario "answer appears on question's author page" do
      author = create(:user)
      new_question = create(:question, author: author)

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(new_question)
      end

      Capybara.using_session('author') do
        sign_in(author)
        visit question_path(new_question)
      end

      Capybara.using_session('user') do
        fill_in 'answer[body]', with: 'Test answer'
        click_button 'Post Your Answer'

        expect(current_path).to eq question_path(new_question)
        expect(page).to have_content question.title

        within '.answers' do
          expect(page).to have_content 'Test answer'
        end
      end

      Capybara.using_session('author') do
        within '.answers' do
          expect(page).to have_content 'Test answer'
          expect(page).to have_css('.best-answer-link')
          expect(page).to have_css('.vote-up')
          expect(page).to have_css('.vote-down')
        end
      end
    end
  end

  scenario 'Unauthenticated user tries answer the question' do
    visit question_path(question)
    click_button 'Post Your Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
