# frozen_string_literal: true

require 'rails_helper'

describe 'gist_id' do
  it 'should return id' do
    url = 'https://gist.github.com/odanetpro/fd69fb3ff2341345606b8fb05d05eb68'

    expect(helper.gist_id(url)).to eq 'fd69fb3ff2341345606b8fb05d05eb68'
  end
end
