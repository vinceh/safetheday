class MigrationForReferrals < ActiveRecord::Migration
  def up
    add_column :users, :total_free_months, :integer, :default => 0
    add_column :users, :current_free_months, :integer, :default => 0
    add_column :users, :referral_code, :string
    add_column :users, :inactive, :boolean, :default => false
    add_column :invoices, :free_month, :boolean, :default => false
  end

  def down
    remove_column :users, :total_free_months
    remove_column :users, :current_free_months
    remove_column :users, :referral_code
    remove_column :users, :inactive
    remove_column :invoices, :free_month
  end
end
