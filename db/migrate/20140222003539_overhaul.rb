class Overhaul < ActiveRecord::Migration
  def change
    remove_column :users, :regional_subscription_id
    add_column :users, :subscription_id, :integer

    add_column :taxes, :country, :string
    add_column :taxes, :state,   :string

    remove_column :taxes, :regional_subscription_id
    remove_column :taxes, :name

    add_column :subscriptions, :stripe, :string

    drop_table :regional_subscriptions
  end
end
