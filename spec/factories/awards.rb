FactoryBot.define do
  factory :award do
    name { "My award" }
    image { nil }
    question factory: :question
    user { nil }
  end
end
