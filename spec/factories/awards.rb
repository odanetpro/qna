FactoryBot.define do
  factory :award do
    name { "MyString" }
    image { nil }
    question factory: :question
    user { nil }
  end
end
