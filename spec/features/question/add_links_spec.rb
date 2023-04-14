# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As a question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/odanetpro/fd69fb3ff2341345606b8fb05d05eb68' }
  given(:google_url) { 'http://google.com' }
  given(:yandex_url) { 'http://yandex.ru' }

  describe 'CREATE' do
    before do
      sign_in(user)
      visit new_question_path
    end

    scenario 'User adds link when asks question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: google_url

      click_on 'Ask'

      expect(page).to have_link 'Google', href: google_url
    end

    scenario 'User adds links when asks question', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      click_on 'add link'

      nested_fields = all('.nested-fields')

      within(nested_fields.first) do
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: google_url
      end

      within(nested_fields.last) do
        fill_in 'Link name', with: 'Yandex'
        fill_in 'Url', with: yandex_url
      end

      click_on 'Ask'
      sleep 2

      expect(page).to have_link 'Google', href: google_url
      expect(page).to have_link 'Yandex', href: yandex_url
    end

    scenario 'User adds wrong link when asks question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'Wrong link'
      fill_in 'Url', with: 'yandex'

      click_on 'Ask'

      expect(page).to_not have_link 'Wrong link', href: 'yandex'
      expect(page).to have_content 'url is invalid'
    end

    scenario 'User adds gist link when asks question', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'Gist'
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      sleep 2

      within('.question .gist-content') do
        expect(page).to have_content "puts 'Hello, world!'"
      end
    end
  end

  describe 'EDIT' do
    scenario 'User adds links when edit question', js: true do
      sign_in(user)

      question = create(:question, author: user)
      visit question_path(question)

      within '.question' do
        click_on 'Edit'

        click_on 'add link'
        click_on 'add link'

        nested_fields = all('.nested-fields')

        within(nested_fields.first) do
          fill_in 'Link name', with: 'Google'
          fill_in 'Url', with: google_url
        end

        within(nested_fields.last) do
          fill_in 'Link name', with: 'Yandex'
          fill_in 'Url', with: yandex_url
        end

        click_on 'Save'

        expect(page).to have_link 'Google', href: google_url
        expect(page).to have_link 'Yandex', href: yandex_url
      end
    end
  end
end
