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

  describe 'DELETE #destroy' do
    describe 'Authenticated user' do
      before { question.subscribers << user }

      it 'subscriber unsubscribe from question' do
        login(user)

        expect do
          delete :destroy, params: { id: question }, format: :js
        end.to change(QuestionSubscription, :count).by(-1)
      end

      it 'not subscriber tries to unsubscribe from question' do
        login(create(:user))

        expect do
          delete :destroy, params: { id: question }, format: :js
        end.to change(QuestionSubscription, :count).by(0)
      end
    end

    describe 'Unauthenticated user' do
      it 'tries to unsubscribe from question' do
        expect do
          delete :destroy, params: { id: question }, format: :js
        end.to change(QuestionSubscription, :count).by(0)
      end
    end
  end
end
