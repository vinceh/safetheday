class Invoice < ActiveRecord::Base

  belongs_to :user

  attr_accessible :stripe_invoice_id, :user_id, :stripe_charge_id, :amount, :stripe_fee
end