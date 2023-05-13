# frozen_string_literal: true

module Api
  module V1
    class AnswersController < BaseController
      before_action :question, only: %i[index create]
      authorize_resource

      def index
        render json: @question.answers, each_serializer: AnswersSerializer
      end

      def show
        @answer = Answer.find(params[:id])
        render json: @answer, serializer: AnswerSerializer
      end

      def create
        @answer = @question.answers.build(answer_params)

        if @answer.save
          render json: @answer, serializer: AnswerSerializer
        else
          render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def question
        @question ||= Question.find(params[:question_id])
      end

      def answer_params
        params.require(:answer).permit(:body,
                                       links_attributes: %i[id name url]).merge(author_id: current_resource_owner.id)
      end
    end
  end
end
