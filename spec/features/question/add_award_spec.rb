# frozen_string_literal: true

require 'rails_helper'

feature 'User can add award to question', "
  In order to reward the user with the best answer
  As a question's author
  I'd like to be able to add award with title and image
" do
  given(:user) { create(:user) }

  before do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User asks a question with award' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    within '.award' do
      fill_in 'Award name', with: 'My award'
      attach_file 'Image', Rails.root.join('spec/attachments/award.png')
    end

    click_on 'Ask'

    within '.question-award' do
      expect(page).to have_content 'My award'
      expect(page).to have_css('img')
    end
  end

  scenario 'User asks a question with award (error blank name)' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    within '.award' do
      fill_in 'Award name', with: ''
      attach_file 'Image', Rails.root.join('spec/attachments/award.png')
    end

    click_on 'Ask'

    expect(page).to have_content "Award name can't be blank"
  end

  scenario 'User asks a question with award (error blank image)' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    within '.award' do
      fill_in 'Award name', with: 'My award'
    end

    click_on 'Ask'

    expect(page).to have_content "Award image can't be blank"
  end
end
