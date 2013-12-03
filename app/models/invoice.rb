class Invoice < ActiveRecord::Base

  belongs_to :user
  before_save :capitalize_currency

  attr_accessible :stripe_invoice_id, :user_id, :stripe_charge_id, :amount, :stripe_fee

  def capitalize_currency
    self.currency.upcase!
  end
end