task :seeder => :environment do
  3.times do
    i = Invoice.new
    i.user_id = 1
    i.stripe_invoice_id = '46251133'
    i.stripe_charge_id = '8624544'
    i.amount = 1299
    i.stripe_fee = 59
    i.save
  end
end

task :invoicer => :environment do
  user = User.first
  invoice = Invoice.find(1)

  ch = Stripe::Charge.retrieve(invoice.stripe_charge_id)
  meta = {}
  user.regional_subscription.taxes.each do |t|
    meta[t.shorthand] = ((t.percentage.to_f/100)*user.regional_subscription.untaxed_amount).round
  end
  ch.metadata = meta
  ch.save
end