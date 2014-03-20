class PendingShipment < ActiveRecord::Base
  belongs_to :invoice

  attr_accessible :shipped_on, :ship_start_date

  def self.create_from_invoice(i)
    p = PendingShipment.new
    p.invoice = i
    p.ship_start_date = i.created_at
    p.save!

    invoice = Stripe::Invoice.retrieve(i.stripe_invoice_id)
    if invoice.lines.data[0].quantity == 2
      p = PendingShipment.new
      p.invoice = i
      p.ship_start_date = i.created_at + 15.days
      p.save!
    end
  end

  def mark_shipped
    self.shipped_on = Time.now
    save!
  end
end