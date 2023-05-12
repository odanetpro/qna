# frozen_string_literal: true

module Api
  module V1
    class AnswersController < BaseController
      authorize_resource

      def index
        @question = Question.find(params[:question_id])
        render json: @question.answers, each_serializer: AnswersSerializer
      end
    end
  end
end
