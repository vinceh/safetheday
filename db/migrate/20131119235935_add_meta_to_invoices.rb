class AddMetaToInvoices < ActiveRecord::Migration
  def up
    add_column :invoices, :shipped_on, :datetime

  end

  def down
    remove_column :invoices, :shipped_on
  end
end
