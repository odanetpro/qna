# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionSubscription, type: :model do
  it { should belong_to(:user).required }
  it { should belong_to(:question).required }

  subject { create(:question_subscription) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:question_id).ignoring_case_sensitivity }
end
