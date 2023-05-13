# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) do
    { 'ACCEPT' => 'application/json' }
  end

  describe '/api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { api_v1_question_answers_path(question) }
    let!(:answers) { create_list(:answer, 3, question: question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 3
      end
    end
  end

  describe '/api/v1/answers/:id' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let(:api_path) { api_v1_answer_path(answer) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')) }

      before do
        answer.comments << create_list(:comment, 2, commentable: answer)
        answer.links << create_list(:link, 2, linkable: answer)
        answer.files.attach(file)
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns all public fields' do
        %w[id body question_id author_id created_at updated_at].each do |attr|
          expect(json['answer'][attr]).to eq answer.send(attr).as_json
        end
      end

      it 'returns all comments' do
        expect(json['answer']['comments'].size).to eq 2
      end

      it 'returns all links' do
        expect(json['answer']['links'].size).to eq 2
      end

      it 'returns files urls' do
        expect(json['answer']['files_urls'].first).to eq rails_blob_path(answer.files.first, only_path: true)
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'with valid attributes' do
        it 'save a new answer in database' do
          expect do
            post api_path,
                 params: { access_token: access_token.token, question_id: question, answer: attributes_for(:answer) },
                 headers: headers
          end.to change(Answer, :count).by(1)
        end

        it 'returns created object' do
          post api_path,
               params: { access_token: access_token.token, question_id: question, answer: attributes_for(:answer) },
               headers: headers

          %w[id body question_id author_id created_at updated_at].each do |attr|
            expect(json['answer']).to have_key(attr)
          end
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect do
            post api_path,
                 params: { access_token: access_token.token, question_id: question,
                           answer: attributes_for(:answer, :invalid) },
                 headers: headers
          end.to_not change(Answer, :count)
        end

        before do
          post api_path,
               params: { access_token: access_token.token, question_id: question,
                         answer: attributes_for(:answer, :invalid) },
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
end
