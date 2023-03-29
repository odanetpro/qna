# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As a question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/odanetpro/fd69fb3ff2341345606b8fb05d05eb68' }
  given(:yandex_url) { 'http://yandex.ru' }

  before do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds link when asks question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end

  scenario 'User adds links when asks question', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    click_on 'add link'

    nested_fields = all('.nested-fields')

    within(nested_fields.first) do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
    end

    within(nested_fields.last) do
      fill_in 'Link name', with: 'Yandex'
      fill_in 'Url', with: yandex_url
    end

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
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
end
