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
    file1 = Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb'))
    file2 = Rack::Test::UploadedFile.new(Rails.root.join('spec/spec_helper.rb'))

    question.files.attach([file1, file2])

    question.answers = create_list(:answer, 3, question: question)
    question.answers.each { |answer| answer.files.attach([file1, file2]) }

    question.answers.first.mark_as_best
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to view the question and the answers to it' do
      question.answers.each { |answer| expect(page).to have_content answer.body }
    end

    scenario 'tries to view the question with attached files' do
      within '.question' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'tries to view the question and the answers with attached files' do
      question.answers.each do |answer|
        within ".answer-#{answer.id}" do
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    scenario 'tries to view the question and the best answers with attached files' do
      within '.best-answer' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit question_path(question)
    end

    scenario 'tries to view the question and the answers to it' do
      question.answers.each { |answer| expect(page).to have_content answer.body }
    end

    scenario 'tries to view the question with attached files' do
      within '.question' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'tries to view the question and the answers with attached files' do
      question.answers.each do |answer|
        within ".answer-#{answer.id}" do
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    scenario 'tries to view the question and the best answers with attached files' do
      within '.best-answer' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end
end
