class CreateMemberships < ActiveRecord::Migration
  def up
    create_table(:regional_subscriptions) do |t|
      t.integer   "subscription_id"
      t.string    "stripe_subscription_id"
      t.string    "state"
      t.timestamps
    end

    create_table(:subscriptions) do |t|
      t.string   "name"
      t.string   "description"
      t.timestamps
    end

    create_table(:taxes) do |t|
      t.integer  "regional_subscription_id"
      t.string   "name"
      t.string   "shorthand"
      t.integer  "percentage"
      t.timestamps
    end
  end

  def down
    drop_table(:regional_subscriptions)
    drop_table(:subscriptions)
    drop_table(:taxes)
  end
end
