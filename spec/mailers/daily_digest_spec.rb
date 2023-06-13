# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyDigestMailer, type: :mailer do
  describe 'digest' do
    let(:user) { create(:user) }
    let(:mail) { DailyDigestMailer.digest(user) }
    let!(:questions) { create_list(:question, 2) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Daily Digest from QnA')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([Rails.application.credentials.mailer[:from_email]])
    end

    it 'renders the body' do
      questions.each do |q|
        expect(mail.body.encoded).to match(q.title)
      end
    end
  end
end
