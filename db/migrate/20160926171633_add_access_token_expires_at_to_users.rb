class AddAccessTokenExpiresAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :access_token_expires_at, :Time
  end
end
