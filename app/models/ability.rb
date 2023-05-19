# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user, params = nil)
    @user = user
    @params = params

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    mark_best_ability
    destroy_links_ability
    show_user_awards_ability

    can :create, [Question, Answer, Comment, QuestionSubscription]
    can %i[update destroy delete_file vote_up vote_down], [Question, Answer], author_id: user.id
    can :me, User, id: user.id
  end

  def mark_best_ability
    can :mark_best, Answer do |answer|
      answer.question.author_id == user.id
    end
  end

  def destroy_links_ability
    can :destroy, Link do |link|
      link.linkable.author_id == user.id
    end
  end

  def show_user_awards_ability
    can :user_awards, Award if @params&.dig(:user_id).to_i == user.id
  end
end
