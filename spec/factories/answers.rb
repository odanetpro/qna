# frozen_string_literal: true

FactoryBot.define do
  sequence :body do |n|
    "AnswerText#{n}"
  end

  factory :answer do
    body
    question factory: :question
    author factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
