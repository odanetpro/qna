# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < BaseController
      authorize_resource

      def index
        @questions = Question.all
        render json: @questions, each_serializer: QuestionsSerializer
      end

      def show
        @question = Question.with_attached_files.find(params[:id])
        render json: @question, serializer: QuestionSerializer
      end
    end
  end
end
