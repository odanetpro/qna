# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples_for 'linkable' do
  it { should have_many(:links).dependent(:destroy) }
  it { should accept_nested_attributes_for :links }
end
