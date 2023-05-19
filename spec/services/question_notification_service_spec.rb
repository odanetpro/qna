# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionNotificationService do
  let(:users) { create_list(:user, 3) }
  let(:mail) { double(ActionMailer::MessageDelivery) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  subject { QuestionNotificationService.new(answer) }

  it 'sends new answer to subscribed users' do
    users.each do |user|
      user.subscribed_questions << question

      expect(NewAnswerMailer).to receive(:notify).with(user, answer).and_return(mail)
      expect(mail).to receive(:deliver_later)
    end

    subject.new_answer_notification
  end
end
