# frozen_string_literal: true

class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    QuestionNotificationService.new(answer).new_answer_notification
  end
end
