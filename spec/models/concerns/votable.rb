# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }
end
