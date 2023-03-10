# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question).required }
  it { should belong_to(:author).required.class_name('User') }

  it { should validate_presence_of :body }
end
