class AddPriceToSubs < ActiveRecord::Migration
  def change
    add_column :subscriptions, :price, :integer
  end
end
