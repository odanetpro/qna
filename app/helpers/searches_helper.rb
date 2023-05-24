# frozen_string_literal: true

module SearchesHelper
  def link_to_commentable(result)
    case result.commentable
    when Question
      link_to  result.commentable.title, question_path(result.commentable)
    when Answer
      link_to  result.commentable.question.title, question_path(result.commentable.question)
    end
  end
end
