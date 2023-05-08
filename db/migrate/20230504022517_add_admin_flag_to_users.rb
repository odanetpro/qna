# frozen_string_literal: true

class AddAdminFlagToUsers < ActiveRecord::Migration[6.1]
  def self.up
    add_column :users, :admin, :boolean, default: false

    execute('UPDATE users SET admin = false')
  end

  def self.down
    remove_column :users, :admin
  end
end
