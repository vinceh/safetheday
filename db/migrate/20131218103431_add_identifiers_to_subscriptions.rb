class AddIdentifiersToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :shorthand, :string
  end
end
