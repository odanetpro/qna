# frozen_string_literal: true

require 'sphinx_helper'

feature 'User can search for all avaliable objects', "
  In order to find needed object
  As a guest
  I'd like to be able to search for the object
" do
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer) }
  given!(:comment) { create(:comment, commentable: question) }
  given!(:user) { create(:user) }
  given(:queries) { [question.title, answer.body, comment.body, user.email] }

  background { visit root_path }

  scenario 'User searches for the existing object', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      queries.each do |query|
        within('.search') do
          fill_in 'search_query', with: query
          select 'all', from: 'search_scope'
          click_button 'Search'
        end

        expect(page).to have_content(query)
      end
    end
  end

  scenario 'Object not found', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within('.search') do
        fill_in 'search_query', with: '123'
        select 'all', from: 'search_scope'
        click_button 'Search'
      end

      expect(page).to have_content('No matches')
    end
  end
end
