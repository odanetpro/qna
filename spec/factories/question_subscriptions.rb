# frozen_string_literal: true

FactoryBot.define do
  factory :question_subscription do
    user factory: :user
    question factory: :question
  end
end
