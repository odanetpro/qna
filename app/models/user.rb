# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :answers, foreign_key: 'author_id', dependent: :destroy, inverse_of: :author
  has_many :questions, foreign_key: 'author_id', dependent: :destroy, inverse_of: :author
  has_many :awards, dependent: :nullify
end
