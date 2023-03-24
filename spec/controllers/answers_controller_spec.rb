# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save a new answer to database' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        end.to change(Answer, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new answer to database' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, author: user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, author: user) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
    end

    it 'renders destroy view' do
      delete :destroy, params: { id: answer }, format: :js
      expect(response).to render_template :destroy
    end
  end

  describe 'POST #mark_best' do
    it 'author of question marks the answer as best' do
      question = create(:question, author: user)
      answer = create(:answer, question: question)

      post :mark_best, params: { id: answer }, format: :js
      question.reload

      expect(question.best_answer).to eq answer
    end

    it 'not author of question marks the answer as best' do
      question = create(:question)
      answer = create(:answer, question: question)

      post :mark_best, params: { id: answer }, format: :js
      question.reload

      expect(question.best_answer).to be_nil
    end

    it 'unauthenticated user tries to mark the answer as best' do
      question = create(:question, author: user)
      answer = create(:answer, question: question)

      logout(user)
      post :mark_best, params: { id: answer }, format: :js
      question.reload

      expect(question.best_answer).to be_nil
    end
  end

  describe 'DELETE #delete_file' do
    let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')) }

    describe 'Authenticated user' do
      it 'deletes attached file' do
        answer = create(:answer, question: question, author: user)
        answer.files.attach(file)

        expect do
          delete :delete_file, params: { id: answer, file_id: answer.files.first }, format: :js
        end.to change(answer.files, :count).by(-1)
      end

      it 'tries to delete some one else attached file' do
        other_answer = create(:answer, question: question)
        other_answer.files.attach(file)

        expect do
          delete :delete_file, params: { id: other_answer, file_id: other_answer.files.first }, format: :js
        end.to change(other_answer.files, :count).by(0)
      end
    end

    it 'Unauthenticated user tries to delete attached file' do
      logout(user)

      answer = create(:answer, question: question, author: user)
      answer.files.attach(file)

      expect do
        delete :delete_file, params: { id: answer, file_id: answer.files.first }, format: :js
      end.to change(answer.files, :count).by(0)
    end
  end
end
