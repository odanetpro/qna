# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionSubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    describe 'Authenticated user' do
      before { login(user) }

      it 'subscribe for question' do
        expect do
          post :create, params: { id: question }, format: :js
        end.to change(QuestionSubscription, :count).by(1)
      end
    end

    describe 'Unauthenticated user' do
      it 'tries to subscribe for question' do
        expect do
          post :create, params: { id: question }, format: :js
        end.to change(QuestionSubscription, :count).by(0)
      end
    end
  end
end
