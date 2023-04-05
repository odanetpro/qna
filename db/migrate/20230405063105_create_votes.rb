# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :value
      t.references :user, null: false, foreign_key: true
      t.belongs_to :votable, polymorphic: true, null: false

      t.timestamps
    end

    add_index :votes, %i[user_id votable_type votable_id], unique: true
  end
end
