# frozen_string_literal: true

class AddConfirmableAndLockableToUsersAndAdminUsers < ActiveRecord::Migration[8.1]
  def up
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string
    add_column :users, :failed_attempts, :integer, default: 0, null: false
    add_column :users, :unlock_token, :string
    add_column :users, :locked_at, :datetime

    add_index :users, :confirmation_token, unique: true
    add_index :users, :unlock_token, unique: true

    add_column :admin_users, :failed_attempts, :integer, default: 0, null: false
    add_column :admin_users, :unlock_token, :string
    add_column :admin_users, :locked_at, :datetime

    add_index :admin_users, :unlock_token, unique: true

    # Existing accounts predate :confirmable — without this they'd be
    # retroactively unconfirmed and locked out of signing in.
    execute "UPDATE users SET confirmed_at = created_at WHERE confirmed_at IS NULL"
  end

  def down
    remove_index :admin_users, :unlock_token
    remove_column :admin_users, :locked_at
    remove_column :admin_users, :unlock_token
    remove_column :admin_users, :failed_attempts

    remove_index :users, :unlock_token
    remove_index :users, :confirmation_token
    remove_column :users, :locked_at
    remove_column :users, :unlock_token
    remove_column :users, :failed_attempts
    remove_column :users, :unconfirmed_email
    remove_column :users, :confirmation_sent_at
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_token
  end
end
