# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  has_many :answers, foreign_key: 'author_id', dependent: :destroy, inverse_of: :author
  has_many :questions, foreign_key: 'author_id', dependent: :destroy, inverse_of: :author
  has_many :comments, foreign_key: 'author_id', dependent: :destroy, inverse_of: :author
  has_many :awards, dependent: :nullify
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :question_subscriptions, dependent: :destroy
  has_many :subscribed_questions, through: :question_subscriptions, source: :question

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def subscribed_for_question?(question)
    question_subscriptions.exists?(question_id: question.id)
  end
end
