class AddCardDetailsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :card_last_four, :string
    add_column :users, :card_type, :string

  end

  def down
    remove_column :users, :card_last_four
    remove_column :users, :card_type
  end
end
