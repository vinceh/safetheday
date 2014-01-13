# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140111083515) do

  create_table "admins", :force => true do |t|
    t.string   "email",               :default => "", :null => false
    t.string   "encrypted_password",  :default => "", :null => false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true

  create_table "feedbacks", :force => true do |t|
    t.string   "description"
    t.string   "subscription"
    t.datetime "member_since"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "invoices", :force => true do |t|
    t.string   "stripe_invoice_id"
    t.integer  "user_id"
    t.string   "stripe_charge_id"
    t.integer  "amount"
    t.integer  "stripe_fee"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.datetime "shipped_on"
    t.string   "subscription_id"
    t.string   "currency"
    t.boolean  "free_month",        :default => false
  end

  create_table "regional_subscriptions", :force => true do |t|
    t.integer  "subscription_id"
    t.string   "stripe_subscription_id"
    t.string   "state"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "price"
    t.string   "shorthand"
  end

  create_table "taxes", :force => true do |t|
    t.integer  "regional_subscription_id"
    t.string   "name"
    t.string   "shorthand"
    t.integer  "percentage"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                    :default => "",    :null => false
    t.string   "encrypted_password",       :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "stripe_customer_id"
    t.datetime "plan_ending_date"
    t.boolean  "cancel_at_period_end",     :default => false
    t.string   "shipping_first_name"
    t.string   "shipping_last_name"
    t.string   "shipping_address_one"
    t.string   "shipping_address_two"
    t.string   "shipping_city"
    t.string   "shipping_state"
    t.string   "shipping_country"
    t.string   "shipping_zipcode"
    t.string   "shipping_phone"
    t.boolean  "shipping_same"
    t.string   "billing_first_name"
    t.string   "billing_last_name"
    t.string   "billing_address_one"
    t.string   "billing_address_two"
    t.string   "billing_city"
    t.string   "billing_state"
    t.string   "billing_country"
    t.string   "billing_zipcode"
    t.string   "billing_phone"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.boolean  "paid",                     :default => false
    t.string   "card_last_four"
    t.string   "card_type"
    t.integer  "regional_subscription_id"
    t.integer  "total_free_months",        :default => 0
    t.integer  "current_free_months",      :default => 0
    t.string   "referral_code"
    t.boolean  "inactive",                 :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
