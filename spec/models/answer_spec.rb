# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_many(:links).dependent(:destroy) }
  it { should belong_to(:question).required }
  it { should belong_to(:author).required.class_name('User') }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'should mark answer as best' do
    question = create(:question)
    answer = create(:answer, question: question)
    answer.mark_as_best

    expect(question.best_answer).to eq answer
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
