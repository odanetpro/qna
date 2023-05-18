# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyDigestMailer, type: :mailer do
  describe 'digest' do
    let(:user) { create(:user) }
    let(:mail) { DailyDigestMailer.digest(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Daily Digest from QnA')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      questions = create_list(:question, 2)

      questions.each do |q|
        expect(mail.body.encoded).to match(q.title)
      end
    end
  end
end
