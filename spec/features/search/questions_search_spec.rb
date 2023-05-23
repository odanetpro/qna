# frozen_string_literal: true

require 'sphinx_helper'

feature 'User can search for question', "
  In order to find needed question
  As a guest
  I'd like to be able to search for the question
" do
  given!(:question) { create(:question) }

  background { visit root_path }

  scenario 'User searches for the existing question', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within('.search') do
        fill_in 'search_query', with: question.title
        select 'question', from: 'search_scope'
        click_button 'Search'
      end

      expect(page).to have_content(question.title)
    end
  end

  scenario 'Question not found', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within('.search') do
        fill_in 'search_query', with: '123'
        select 'question', from: 'search_scope'
        click_button 'Search'
      end

      expect(page).to_not have_content(question.title)
    end
  end
end
