# frozen_string_literal: true

require 'sphinx_helper'

feature 'User can search for comments', "
  In order to find needed comments
  As a guest
  I'd like to be able to search for the comments
" do
  given!(:question) { create(:question) }
  given!(:comment) { create(:comment, commentable: question) }

  background { visit root_path }

  scenario 'User searches for the existing comment', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within('.search') do
        fill_in 'search_query', with: comment.body
        select 'comment', from: 'search_scope'
        click_button 'Search'
      end

      expect(page).to have_content(comment.body)
    end
  end

  scenario 'Comment not found', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within('.search') do
        fill_in 'search_query', with: '123'
        select 'comment', from: 'search_scope'
        click_button 'Search'
      end

      expect(page).to_not have_content(comment.body)
    end
  end
end
