# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'ACCEPT' => 'application/json' }
  end

  describe '/api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'returns author object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'returns short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body author_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe '/api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:api_path) { api_v1_question_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')) }

      before do
        question.links << create_list(:link, 2, linkable: question)
        question.comments << create_list(:comment, 2, commentable: question)
        question.files.attach(file)

        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns all public fields' do
        %w[id title body author_id created_at updated_at].each do |attr|
          expect(json['question'][attr]).to eq question.send(attr).as_json
        end
      end

      it 'returns all links' do
        expect(json['question']['links'].size).to eq 2
      end

      it 'returns all comments' do
        expect(json['question']['comments'].size).to eq 2
      end

      it 'returns files urls' do
        expect(json['question']['files_urls'].first).to eq rails_blob_path(question.files.first, only_path: true)
      end
    end
  end

  describe 'POST /api/v1/questions/' do
    let(:api_path) { api_v1_questions_path }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'with valid attributes' do
        it 'save a new question in the database' do
          expect do
            post api_path, params: { access_token: access_token.token, question: attributes_for(:question) },
                           headers: headers
          end.to change(Question, :count).by(1)
        end

        it 'returns created object' do
          post api_path, params: { access_token: access_token.token, question: attributes_for(:question) },
                         headers: headers

          %w[id title body author_id created_at updated_at].each do |attr|
            expect(json['question']).to have_key(attr)
          end
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect do
            post api_path, params: { access_token: access_token.token, question: attributes_for(:question, :invalid) },
                           headers: headers
          end.to_not change(Question, :count)
        end

        before do
          post api_path, params: { access_token: access_token.token, question: attributes_for(:question, :invalid) },
                         headers: headers
        end

        it 'returns errors' do
          expect(json['errors'].size).to be > 0
        end

        it 'returns 422 status' do
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
      let(:api_path) { api_v1_question_path(create(:question)) }
    end

    context 'authorized' do
      let(:author) { create(:user) }
      let(:question) { create(:question, author: author) }
      let(:api_path) { api_v1_question_path(question) }

      context 'author' do
        let(:access_token) { create(:access_token, resource_owner_id: author.id) }

        context 'with valid attributes' do
          it 'changes question attributes' do
            patch api_path, params: { access_token: access_token.token, id: question, question: { title: 'NewTitle', body: 'NewBody' } },
                            headers: headers

            expect(json['question']['title']).to eq 'NewTitle'
            expect(json['question']['body']).to eq 'NewBody'
          end
        end

        context 'with invalid attributes' do
          before do
            patch api_path, params: { access_token: access_token.token, id: question, question: attributes_for(:question, :invalid) },
                            headers: headers
          end

          it 'does not change question' do
            expect(question.title).to eq 'MyString'
            expect(question.body).to eq 'MyText'
          end

          it 'returns 422 status' do
            expect(response.status).to eq 422
          end
        end
      end

      context 'not author' do
        let(:access_token) { create(:access_token, resource_owner_id: create(:user).id) }

        it 'tries to change question attributes' do
          patch api_path, params: { access_token: access_token.token, id: question, question: { title: 'NewTitle', body: 'NewBody' } },
                          headers: headers

          expect(question.title).to eq 'MyString'
          expect(question.body).to eq 'MyText'
        end
      end
    end
  end
end
