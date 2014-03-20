class Invoice < ActiveRecord::Base

  belongs_to :user
  before_save :capitalize_currency

  attr_accessible :stripe_invoice_id, :user_id, :stripe_charge_id, :amount, :stripe_fee, :shipped_on

  def capitalize_currency
    self.currency.upcase!
  end

  def sub_type
    if self.subscription_id.include?("reg")
      return "The Wingman"
    else
      return "The Connoisseur"
    end
  end
end