# frozen_string_literal: true

class CreateQuestionSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :question_subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end

    add_index :question_subscriptions, %i[user_id question_id], unique: true
  end
end
