# frozen_string_literal: true

FactoryBot.define do
  sequence :body do |n|
    "AnswerText#{n}"
  end

  factory :answer do
    body
    question { nil }

    trait :invalid do
      body { nil }
    end
  end
end
