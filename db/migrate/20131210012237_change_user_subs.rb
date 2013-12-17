class ChangeUserSubs < ActiveRecord::Migration
  def change
    remove_column :users, :subscription_id
    add_column :users, :regional_subscription_id, :integer
  end
end
