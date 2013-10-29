class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.string   :stripe_customer_id
      t.string   :subscription_id
      t.datetime :plan_ending_date
      t.boolean  :cancel_at_period_end, :default => false

      t.string   :shipping_first_name
      t.string   :shipping_last_name
      t.string   :shipping_address_one
      t.string   :shipping_address_two
      t.string   :shipping_city
      t.string   :shipping_state
      t.string   :shipping_country
      t.string   :shipping_zipcode
      t.string   :shipping_phone
      t.boolean  :shipping_same

      t.string   :billing_first_name
      t.string   :billing_last_name
      t.string   :billing_address_one
      t.string   :billing_address_two
      t.string   :billing_city
      t.string   :billing_state
      t.string   :billing_country
      t.string   :billing_zipcode
      t.string   :billing_phone

      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    # add_index :users, :authentication_token, :unique => true
  end
end
