# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :search, :search }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Question' do
      it { should be_able_to :create, Question }

      it { should be_able_to :update, create(:question, author: user) }
      it { should_not be_able_to :update, create(:question, author: other) }

      it { should be_able_to :destroy, create(:question, author: user) }
      it { should_not be_able_to :destroy, create(:question, author: other) }

      it { should be_able_to :delete_file, create(:question, author: user) }
      it { should_not be_able_to :delete_file, create(:question, author: other) }
    end

    context 'Answer' do
      it { should be_able_to :create, Answer }

      it { should be_able_to :update, create(:answer, author: user) }
      it { should_not be_able_to :update, create(:answer, author: other) }

      it { should be_able_to :destroy, create(:answer, author: user) }
      it { should_not be_able_to :destroy, create(:answer, author: other) }

      it { should be_able_to :delete_file, create(:answer, author: user) }
      it { should_not be_able_to :delete_file, create(:answer, author: other) }

      it { should be_able_to :mark_best, create(:answer, question: create(:question, author: user)) }
      it { should_not be_able_to :mark_best, create(:answer, question: create(:question, author: other)) }
    end

    context 'Comment' do
      it { should be_able_to :create, Comment }
    end

    context 'Vote' do
      it { should be_able_to :vote_up, create(:question, author: other) }
      it { should_not be_able_to :vote_up, create(:question, author: user) }

      it { should be_able_to :vote_down, create(:question, author: other) }
      it { should_not be_able_to :vote_down, create(:question, author: user) }

      it { should be_able_to :vote_up, create(:answer, author: other) }
      it { should_not be_able_to :vote_up, create(:answer, author: user) }

      it { should be_able_to :vote_down, create(:answer, author: other) }
      it { should_not be_able_to :vote_down, create(:answer, author: user) }
    end

    context 'Link' do
      it { should be_able_to :destroy, create(:link, linkable: create(:question, author: user)) }
      it { should_not be_able_to :destroy, create(:link, linkable: create(:question, author: other)) }

      it { should be_able_to :destroy, create(:link, linkable: create(:answer, author: user)) }
      it { should_not be_able_to :destroy, create(:link, linkable: create(:answer, author: other)) }
    end

    context 'show award' do
      it 'for owner' do
        ability = Ability.new(user, user_id: user.id)
        expect(ability).to be_able_to(:user_awards, Award)
      end

      it 'for other user' do
        ability = Ability.new(user, user_id: create(:user).id)
        expect(ability).to_not be_able_to(:user_awards, Award)
      end
    end

    context 'Profile' do
      it { should be_able_to :me, user }
      it { should_not be_able_to :me, other }
    end

    context 'QuestionSubscription' do
      it { should be_able_to :create, QuestionSubscription }
      it { should be_able_to :destroy, QuestionSubscription }
    end
  end
end
