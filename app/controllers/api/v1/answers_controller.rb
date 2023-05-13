# frozen_string_literal: true

module Api
  module V1
    class AnswersController < BaseController
      before_action :question, only: %i[index create]
      before_action :answer, only: %i[show create update]
      authorize_resource

      def index
        render json: @question.answers, each_serializer: AnswersSerializer
      end

      def show
        render json: @answer, serializer: AnswerSerializer
      end

      def create
        if @answer.save
          render json: @answer, serializer: AnswerSerializer
        else
          render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @answer.update(answer_params)
          render json: @answer, serializer: AnswerSerializer
        else
          render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def question
        @question ||= Question.find(params[:question_id])
      end

      def answer
        @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : question.answers.build(answer_params)
      end

      def answer_params
        params.require(:answer).permit(:body,
                                       links_attributes: %i[id name url]).merge(author_id: current_resource_owner.id)
      end
    end
  end
end
