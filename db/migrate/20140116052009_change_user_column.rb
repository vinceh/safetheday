class ChangeUserColumn < ActiveRecord::Migration
  def up
    change_column :users, :inactive, :boolean, :default => true
  end

  def down
    change_column :users, :inactive, :boolean, :default => false
  end
end
