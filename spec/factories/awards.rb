FactoryBot.define do
  factory :award do
    name { "My award" }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/attachments/award.png')) }
    question factory: :question
    user { nil }
  end
end
