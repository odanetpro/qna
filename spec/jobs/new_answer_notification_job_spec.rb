# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:service) { double(QuestionNotificationService) }
  let(:answer) { create(:answer) }

  before do
    allow(QuestionNotificationService).to receive(:new).with(answer).and_return(service)
  end

  it 'calls DailyDigest#send_digest' do
    expect(service).to receive(:new_answer_notification)
    NewAnswerNotificationJob.perform_now(answer)
  end
end
