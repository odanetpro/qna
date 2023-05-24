# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'POST #search' do
    it 'renders index view' do
      post :search, params: { search_query: '123', search_scope: 'question' }
      expect(response).to render_template :search_result
    end
  end
end
