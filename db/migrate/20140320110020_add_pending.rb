class AddPending < ActiveRecord::Migration
  def change
    create_table(:pending_shipments) do |t|
      t.integer   :invoice_id
      t.datetime  :shipped_on
      t.datetime  :ship_start_date
      t.timestamps
    end
  end
end
