# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #create' do
    describe 'Authenticated user' do
      before { login(user) }

      it 'creates new comment' do
        commentable = create(:question)

        expect do
          post :create, params: { "#{commentable.class.name.underscore}_id": commentable.id,
                                  comment: attributes_for(:comment).merge(commentable: commentable,
                                                                          commentable_type: commentable.class.name) }, format: :js
        end.to change(commentable.comments, :count).by(1)
      end
    end

    it 'Unauthenticated user tries to create comment' do
      commentable = create(:question)

      expect do
        post :create, params: { "#{commentable.class.name.underscore}_id": commentable.id,
                                comment: attributes_for(:comment).merge(commentable: commentable,
                                                                        commentable_type: commentable.class.name) }, format: :js
      end.to change(commentable.comments, :count).by(0)
    end
  end
end
