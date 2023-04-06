# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples_for 'votable controller' do
  before { login(user) }

  describe 'POST #vote_up' do
    it 'up rating of the votable by 1' do
      expect do
        post :vote_up, params: { id: voted }, format: :json
      end.to change(Vote, :count).by(1)

      expect(assigns(:vote).value).to eq(1)
    end

    it 'responds with success' do
      post :vote_up, params: { id: voted }, format: :json
      expect(response).to have_http_status(:ok)
    end

    it 'tries to vote up multiple times in a row' do
      expect do
        2.times do
          post :vote_up, params: { id: voted }, format: :json
        end
      end.to change(Vote, :count).by(1)

      expect(voted.votes.sum(:value)).to eq(1)
    end

    it 'cancellation of up vote' do
      expect do
        post :vote_up, params: { id: voted }, format: :json
        post :vote_down, params: { id: voted }, format: :json
      end.to change(Vote, :count).by(0)
    end

    it 'change vote from up to down' do
      post :vote_up, params: { id: voted }, format: :json
      post :vote_down, params: { id: voted }, format: :json
      post :vote_down, params: { id: voted }, format: :json
      expect(assigns(:vote).value).to eq(-1)
    end

    it 'author tries to vote up' do
      voted.update(author_id: user.id)

      expect do
        post :vote_up, params: { id: voted }, format: :json
      end.to change(Vote, :count).by(0)
    end

    it 'unauthenticated user tries to vote up' do
      logout(user)
      expect do
        post :vote_up, params: { id: voted }, format: :json
      end.to change(Vote, :count).by(0)
    end
  end

  describe 'POST #vote_down' do
    it 'down rating of the votable by 1' do
      expect do
        post :vote_down, params: { id: voted }, format: :json
      end.to change(Vote, :count).by(1)

      expect(assigns(:vote).value).to eq(-1)
    end

    it 'responds with success' do
      post :vote_down, params: { id: voted }, format: :json
      expect(response).to have_http_status(:ok)
    end

    it 'tries to vote down multiple times in a row' do
      expect do
        2.times do
          post :vote_down, params: { id: voted }, format: :json
        end
      end.to change(Vote, :count).by(1)

      expect(voted.votes.sum(:value)).to eq(-1)
    end

    it 'cancellation of down vote' do
      expect do
        post :vote_down, params: { id: voted }, format: :json
        post :vote_up, params: { id: voted }, format: :json
      end.to change(Vote, :count).by(0)
    end

    it 'change vote from down to up' do
      post :vote_down, params: { id: voted }, format: :json
      post :vote_up, params: { id: voted }, format: :json
      post :vote_up, params: { id: voted }, format: :json
      expect(assigns(:vote).value).to eq(1)
    end

    it 'author tries to vote down' do
      voted.update(author_id: user.id)

      expect do
        post :vote_down, params: { id: voted }, format: :json
      end.to change(Vote, :count).by(0)
    end

    it 'unauthenticated user tries to vote down' do
      logout(user)
      expect do
        post :vote_down, params: { id: voted }, format: :json
      end.to change(Vote, :count).by(0)
    end
  end
end
