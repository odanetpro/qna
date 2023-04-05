# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:votable) }

  it { should validate_inclusion_of(:value).in_array([-1, 1]) }

  subject { create(:vote) }
  it { should validate_uniqueness_of(:user_id).scoped_to(%i[votable_type votable_id]).ignoring_case_sensitivity }

  it 'should set vote value to like' do
    vote = create(:vote, value: -1)
    vote.set_like!
    vote.reload
    expect(vote.value).to eq(1)
  end

  it 'should set vote value to dislike' do
    vote = create(:vote, value: 1)
    vote.set_dislike!
    vote.reload
    expect(vote.value).to eq(-1)
  end
end
