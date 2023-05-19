# frozen_string_literal: true

class QuestionNotificationService
  def initialize(answer)
    @answer = answer
  end

  def new_answer_notification
    @answer.question.subscribers.find_each do |subscriber|
      NewAnswerMailer.notify(subscriber, @answer).deliver_later
    end
  end
end
