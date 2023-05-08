# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let!(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:image) { Rack::Test::UploadedFile.new(Rails.root.join('spec/attachments/award.png')) }
  let(:award) { create(:award, question: question, image: image, user: user) }

  describe 'GET #user_awards' do
    context 'for owner' do
      before { login(user) }

      it 'assigns user' do
        get :user_awards, params: { user_id: user.id }

        expect(assigns(:user)).to eq user
      end

      it 'assigns award' do
        image = Rack::Test::UploadedFile.new(Rails.root.join('spec/attachments/award.png'))
        user.awards << create(:award, image: image)

        get :user_awards, params: { user_id: user.id }

        expect(assigns(:awards)).to eq user.awards
      end
    end

    context 'for other user' do
      before { login(create(:user)) }

      it 'assigns user' do
        get :user_awards, params: { user_id: user.id }

        expect(assigns(:user)).to eq user
      end

      it 'not assigns award' do
        image = Rack::Test::UploadedFile.new(Rails.root.join('spec/attachments/award.png'))
        user.awards << create(:award, image: image)

        get :user_awards, params: { user_id: user.id }

        expect(assigns(:awards)).to_not eq user.awards
      end

      it 'redirects to root' do
        get :user_awards, params: { user_id: user.id }

        expect(response).to redirect_to root_path
      end
    end
  end
end
