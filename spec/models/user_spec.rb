# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy).with_foreign_key(:author_id).inverse_of(:author) }
  it { should have_many(:questions).dependent(:destroy).with_foreign_key(:author_id).inverse_of(:author) }
  it { should have_many(:comments).dependent(:destroy).with_foreign_key(:author_id).inverse_of(:author) }
  it { should have_many(:awards).dependent(:nullify) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:question_subscriptions).dependent(:destroy) }
  it { should have_many(:subscribed_questions).through(:question_subscriptions).source(:question) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('FindForOauthService') }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)

      User.find_for_oauth(auth)
    end
  end
end
