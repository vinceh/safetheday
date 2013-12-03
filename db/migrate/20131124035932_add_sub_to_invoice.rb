class AddSubToInvoice < ActiveRecord::Migration
  def up
    add_column :invoices, :subscription_id, :string

  end

  def down
    remove_column :invoices, :subscription_id
  end
end
