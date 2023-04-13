# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples_for 'commentable' do
  it { should have_many(:comments).dependent(:destroy) }
  it { should accept_nested_attributes_for :comments }
end