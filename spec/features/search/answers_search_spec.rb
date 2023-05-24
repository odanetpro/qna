# frozen_string_literal: true

require 'sphinx_helper'

feature 'User can search for answer', "
  In order to find needed answer
  As a guest
  I'd like to be able to search for the answer
" do
  given!(:answer) { create(:answer) }

  background { visit root_path }

  scenario 'User searches for the existing answer', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within('.search') do
        fill_in 'search_query', with: answer.body
        select 'answer', from: 'search_scope'
        click_button 'Search'
      end

      expect(page).to have_content(answer.body)
    end
  end

  scenario 'Answer not found', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within('.search') do
        fill_in 'search_query', with: '123'
        select 'answer', from: 'search_scope'
        click_button 'Search'
      end

      expect(page).to_not have_content(answer.body)
    end
  end
end
