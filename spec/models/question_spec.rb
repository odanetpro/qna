# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:author).required.class_name('User') }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end
