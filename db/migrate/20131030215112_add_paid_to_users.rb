class AddPaidToUsers < ActiveRecord::Migration
  def up
    add_column :users, :paid, :boolean, :default => false

    create_table(:invoices) do |t|
      t.string   "stripe_invoice_id"
      t.integer  "user_id"
      t.string   "stripe_charge_id"
      t.integer  "amount"
      t.integer  "stripe_fee"
      t.timestamps
    end
  end

  def down
    remove_column :users, :paid
    drop_table :invoices
  end
end
