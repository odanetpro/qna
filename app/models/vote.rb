# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, inclusion: { in: [-1, 1] }
  validates :user_id, uniqueness: { scope: %i[votable_type votable_id] }

  def set_like!
    self.value = 1
    save!
  end

  def set_dislike!
    self.value = -1
    save!
  end
end
