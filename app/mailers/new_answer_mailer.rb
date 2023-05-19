# frozen_string_literal: true

class NewAnswerMailer < ApplicationMailer
  def notify(user, answer)
    @answer = answer
    mail to: user.email
  end
end
