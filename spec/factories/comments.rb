FactoryBot.define do
  factory :comment do
    body { "MyText" }
    author factory: :user
    commentable { nil }
  end
end
