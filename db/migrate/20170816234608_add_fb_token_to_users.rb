class AddFBTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :fb_token, :string
  end
end
