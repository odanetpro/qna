# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyDigestService do
  let(:users) { create_list(:user, 3) }
  let(:mail) { double(ActionMailer::MessageDelivery) }

  it 'sends daily digest to all users' do
    users.each do |user|
      expect(DailyDigestMailer).to receive(:digest).with(user).and_return(mail)
      expect(mail).to receive(:deliver_later)
    end

    subject.send_digest
  end
end
