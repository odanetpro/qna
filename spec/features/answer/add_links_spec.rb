# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As a question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/odanetpro/fd69fb3ff2341345606b8fb05d05eb68' }
  given(:google_url) { 'http://google.com' }
  given(:yandex_url) { 'http://yandex.ru' }

  before do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds link when give an answer', js: true do
    fill_in 'answer[body]', with: 'Test answer'
    fill_in 'Link name', with: 'Google'
    fill_in 'Url', with: google_url

    click_button 'Post Your Answer'

    within '.answers' do
      expect(page).to have_link 'Google', href: google_url
    end
  end

  scenario 'User adds links when give an answer', js: true do
    fill_in 'answer[body]', with: 'Test answer'

    within('.new-answer') do
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

      click_button 'Post Your Answer'
    end

    within('.answers') do
      expect(page).to have_link 'Google', href: google_url
      expect(page).to have_link 'Yandex', href: yandex_url
    end
  end

  scenario 'User adds wrong link when give an answer', js: true do
    fill_in 'answer[body]', with: 'Test answer'
    fill_in 'Link name', with: 'Wrong link'
    fill_in 'Url', with: 'yandex'

    click_button 'Post Your Answer'

    expect(page).to_not have_link 'Wrong link', href: 'yandex'
    expect(page).to have_content 'url is invalid'
  end

  scenario 'User adds gist link when give an answer', js: true do
    fill_in 'answer[body]', with: 'Test answer'

    fill_in 'Link name', with: 'Gist'
    fill_in 'Url', with: gist_url

    click_button 'Post Your Answer'

    within('.answers .gist-content') do
      expect(page).to have_content "puts 'Hello, world!'"
    end
  end
end
