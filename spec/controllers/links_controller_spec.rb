# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }

  describe 'DELETE #delete_link' do
    let(:google_url) { 'http://google.com' }

    describe 'Authenticated user' do
      before { login(user) }

      it 'deletes link' do
        linkable = create(:question, author: user)
        linkable.links << create(:link, name: 'Google', url: google_url, linkable: linkable)

        expect do
          delete :destroy, params: { id: linkable.links.first }, format: :js
        end.to change(linkable.links, :count).by(-1)
      end

      it 'tries to delete some one else link' do
        linkable = create(:question)
        linkable.links << create(:link, name: 'Google', url: google_url, linkable: linkable)

        expect do
          delete :destroy, params: { id: linkable.links.first }, format: :js
        end.to change(linkable.links, :count).by(0)
      end
    end

    it 'Unauthenticated user tries to delete link' do
      linkable = create(:question)
      linkable.links << create(:link, name: 'Google', url: google_url, linkable: linkable)

      expect do
        delete :destroy, params: { id: linkable.links.first }, format: :js
      end.to change(linkable.links, :count).by(0)
    end
  end
end
