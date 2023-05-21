# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/new_answer
class NewAnswerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/new_answer/notify
  def notify
    NewAnswerMailer.notify(User.first, Answer.first)
  end
end
