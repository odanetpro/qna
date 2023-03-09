# frozen_string_literal: true

require 'rails_helper'

feature 'User can view the question and the answers to it', "
  In order to find a solution
  As any user (authenticated or not)
  I'd like to be able to view the question and the answers to it on the same page
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    question.answers = create_list(:answer, 3, question: question)
  end

  scenario 'Authenticated user tries view the question and the answers to it' do
    sign_in(user)

    visit question_path(question)
    question.answers.each { |answer| expect(page).to have_content answer.body }
  end

  scenario 'Unauthenticated user tries view the question and the answers to it' do
    visit question_path(question)
    question.answers.each { |answer| expect(page).to have_content answer.body }
  end
end
