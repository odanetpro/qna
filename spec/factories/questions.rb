# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { 'MyString' }
    body { 'MyText' }
    author factory: :user

    trait :invalid do
      title { nil }
    end
  end
end
