# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.references :author, null: false, foreign_key: { to_table: 'users' }
      t.belongs_to :commentable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
