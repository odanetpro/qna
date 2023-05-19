# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'renders show view' do
      get :show, params: { id: question }
      expect(response).to render_template :show
    end

    it 'assigns new link for answer' do
      create(:answer, question: question)
      get :show, params: { id: question }
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end

    it 'assigns a new award' do
      expect(assigns(:question).award).to be_a_new(Award)
    end

    it 'assigns a new link' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'save a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end

      it 'subscribe for question' do
        expect do
          post :create, params: { question: attributes_for(:question) }
        end.to change(QuestionSubscription, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post :create, params: { question: attributes_for(:question, :invalid) }
        end.to_not change(Question, :count)
      end

      it 're-render new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end

    context 'with award' do
      it 'save a new award in the database' do
        image = Rack::Test::UploadedFile.new(Rails.root.join('spec/attachments/award.png'))

        expect do
          post :create,
               params: { question: attributes_for(:question).merge(award_attributes: attributes_for(:award,
                                                                                                    image: image)) }
        end.to change(Award, :count).by(1)
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'NewTitle', body: 'NewBody' } }, format: :js

        question.reload

        expect(question.title).to eq 'NewTitle'
        expect(question.body).to eq 'NewBody'
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      let!(:question_title) { question.title }

      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'does not change question' do
        question.reload

        expect(question.title).to eq question_title
        expect(question.body).to eq 'MyText'
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end

    it 'tries to update some one else question' do
      login(user)

      other_question = create(:question, author: create(:user))
      patch :update, params: { id: other_question, question: { title: 'NewTitle', body: 'NewBody' } }, format: :js

      other_question.reload

      expect(other_question.title).to_not eq 'NewTitle'
      expect(other_question.body).to_not eq 'NewBody'
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, author: user) }

    before { login(user) }

    it 'deletes the question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'tries to delete some one else question' do
      other_question = create(:question)
      expect { delete :destroy, params: { id: other_question } }.to change(Question, :count).by(0)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end

  describe 'DELETE #delete_file' do
    let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')) }

    describe 'Authenticated user' do
      before { login(user) }

      it 'deletes attached file' do
        question = create(:question, author: user)
        question.files.attach(file)

        expect do
          delete :delete_file, params: { id: question, file_id: question.files.first },
                               format: :js
        end.to change(question.files, :count).by(-1)
      end

      it 'tries to delete some one else attached file' do
        other_question = create(:question)
        other_question.files.attach(file)

        expect do
          delete :delete_file, params: { id: other_question, file_id: other_question.files.first }, format: :js
        end.to change(other_question.files, :count).by(0)
      end
    end

    it 'Unauthenticated user tries to delete attached file' do
      question = create(:question, author: user)
      question.files.attach(file)

      expect do
        delete :delete_file, params: { id: question, file_id: question.files.first }, format: :js
      end.to change(question.files, :count).by(0)
    end
  end

  it_behaves_like 'votable controller' do
    let!(:voted) { create(:question) }
  end
end
