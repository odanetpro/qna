# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy).with_foreign_key(:author_id).inverse_of(:author) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
end
