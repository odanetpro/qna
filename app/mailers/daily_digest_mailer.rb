# frozen_string_literal: true

class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.for_last_day

    return unless @questions.any?

    mail to: user.email
  end
end
