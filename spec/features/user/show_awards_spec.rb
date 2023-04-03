# frozen_string_literal: true

require 'rails_helper'

feature 'User can view the awards he has received', "
  In order to increase sense of self-worth
  As authenticated user
  I'd like to be able to view the list of my awards (question's title, award's name and image)
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:image) { Rack::Test::UploadedFile.new(Rails.root.join('spec/attachments/award.png')) }

  describe 'Authenticated user' do
    before { sign_in(user) }

    scenario 'views a list of their awards' do
      award = create(:award, question: question, image: image, user: user)
      visit user_awards_path(user)

      expect(page).to have_css('img')
      expect(page).to have_content question.title
      expect(page).to have_content award.name
    end

    scenario " tries to view a list of other users's awards" do
      other_user = create(:user)
      create(:award, question: question, image: image, user: other_user)
      visit user_awards_path(other_user)

      expect(page).to have_content "You don't have permission to view this user's awards"
    end
  end

  scenario 'Unauthenticated user tries to view the list of awards' do
    visit user_awards_path(user)

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
