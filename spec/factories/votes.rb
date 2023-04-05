FactoryBot.define do
  factory :vote do
    value { 1 }
    user factory: :user
    votable factory: :question
  end
end
