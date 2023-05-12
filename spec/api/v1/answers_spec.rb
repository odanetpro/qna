# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
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
end
