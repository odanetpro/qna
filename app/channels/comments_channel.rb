# frozen_string_literal: true

class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "comments_for_question_#{params['question_id']}_and_for_its_answers"
  end
end
