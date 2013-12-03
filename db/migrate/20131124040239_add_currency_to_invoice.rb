class AddCurrencyToInvoice < ActiveRecord::Migration
  def up
    add_column :invoices, :currency, :string

  end

  def down
    remove_column :invoices, :currency
  end
end
