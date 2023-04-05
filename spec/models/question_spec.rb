# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'linkable'
  it_behaves_like 'votable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_one(:award).dependent(:destroy) }
  it { should belong_to(:author).required.class_name('User') }
  it { should belong_to(:best_answer).optional.class_name('Answer') }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :award }

  it 'should reset best answer' do
    question = create(:question)
    answer = create(:answer, question: question)

    question.best_answer = answer
    question.reset_best_answer

    expect(question.best_answer).to be_nil
  end

  it 'should return answers other than the best' do
    question = create(:question)
    answers = []
    3.times { answers << create(:answer, question: question) }
    answers[0].mark_as_best

    expect(question.other_answers).to eq answers[1..]
  end

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
