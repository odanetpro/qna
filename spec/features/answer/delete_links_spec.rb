# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete link from his answer', "
  In order to remove additional info from my answer
  As a answers's author
  I'd like to be able to remove links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/odanetpro/fd69fb3ff2341345606b8fb05d05eb68' }
  given(:google_url) { 'http://google.com' }

  describe 'Author', js: true do
    given!(:answer) { create(:answer, question: question, author: user) }

    before do
      sign_in(user)
    end

    scenario 'remove link from his answer' do
      link = create(:link, name: 'Google', url: google_url, linkable: answer)
      answer.links << link

      visit(question_path(question))

      within("#answer-links-#{answer.id}") do
        expect(page).to have_link 'Google', href: google_url

        accept_confirm { click_on('Remove') }

        expect(page).to_not have_link 'Google', href: google_url
      end
    end

    scenario 'remove gist link from his answer' do
      link = create(:link, url: gist_url, linkable: answer)
      answer.links << link

      visit(question_path(question))

      within("#answer-links-#{answer.id}") do
        expect(page).to have_css "#link-#{link.id}"

        accept_confirm { click_on('Remove') }

        expect(page).to_not have_css "#link-#{link.id}"
      end
    end
  end

  scenario 'Other user try to remove link from answer', js: true do
    answer = create(:answer, question: question)
    link = create(:link, name: 'Google', url: google_url, linkable: answer)
    answer.links << link

    sign_in(user)
    visit(question_path(question))

    within("#answer-links-#{answer.id}") do
      expect(page).to_not have_link 'Remove'
    end
  end

  scenario 'Unauthenticeted user try to remove link from answer', js: true do
    answer = create(:answer, question: question)
    link = create(:link, name: 'Google', url: google_url, linkable: answer)
    answer.links << link

    visit(question_path(question))

    within("#answer-links-#{answer.id}") do
      expect(page).to_not have_link 'Remove'
    end
  end
end
