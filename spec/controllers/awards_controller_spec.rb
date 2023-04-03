# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:image) { Rack::Test::UploadedFile.new(Rails.root.join('spec/attachments/award.png')) }
  let(:award) { create(:award, question: question, image: image, user: user) }

  describe 'GET #user_awards' do
    it 'assigns user' do
      login(user)
      get :user_awards, params: { user_id: user.id }

      expect(assigns(:user)).to eq user
    end

    it 'redirects to root' do
      login(create(:user))
      get :user_awards, params: { user_id: user.id }
      expect(response).to redirect_to root_path
    end
  end
end
