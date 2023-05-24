# frozen_string_literal: true

require 'sphinx_helper'

feature 'User can search for users', "
  In order to find needed users
  As a guest
  I'd like to be able to search for the users
" do
  given!(:user) { create(:user) }

  background { visit root_path }

  scenario 'User searches for the existing user', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within('.search') do
        fill_in 'search_query', with: user.email
        select 'user', from: 'search_scope'
        click_button 'Search'
      end

      expect(page).to have_content(user.email)
    end
  end

  scenario 'User not found', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within('.search') do
        fill_in 'search_query', with: '123'
        select 'user', from: 'search_scope'
        click_button 'Search'
      end

      expect(page).to_not have_content(user.email)
    end
  end
end
