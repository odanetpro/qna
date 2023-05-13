# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < BaseController
      before_action :question, only: %i[show create update destroy]
      authorize_resource

      def index
        @questions = Question.all
        render json: @questions, each_serializer: QuestionsSerializer
      end

      def show
        render json: @question, serializer: QuestionSerializer
      end

      def create
        if @question.save
          render json: @question, serializer: QuestionSerializer
        else
          render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @question.update(question_params)
          render json: @question, serializer: QuestionSerializer
        else
          render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @question.destroy
        render json: @question, serializer: QuestionSerializer
      end

      private

      def question
        @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new(question_params)
      end

      def question_params
        params.require(:question).permit(:title, :body, links_attributes: %i[id name url],
                                                        award_attributes: %i[name image]).merge(author_id: current_resource_owner.id)
      end
    end
  end
end
