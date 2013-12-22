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

task :subber => :environment do
  s = Subscription.new
  s.name = "The Adventurer"
  s.description = "Luxury Condoms"
  s.price = 1599
  s.shorthand = "adv_bi"
  s.save!

  r = RegionalSubscription.new
  r.subscription = s
  r.stripe_subscription_id = "24_ca_bi"
  r.state = "BC"
  r.save!

  t = Tax.new
  t.name = "gst_bc"
  t.shorthand = "GST"
  t.percentage = 5
  t.regional_subscription = r
  t.save!

  t2 = Tax.new
  t2.name = "pst_bc"
  t2.shorthand = "PST"
  t2.percentage = 8
  t2.regional_subscription = r
  t2.save!

  s = Subscription.new
  s.name = "The Journeyman"
  s.description = "The most amazing condoms"
  s.price = 1299
  s.shorthand = "jour_bi"
  s.save!

  r = RegionalSubscription.new
  r.subscription = s
  r.stripe_subscription_id = "12_ca_bi"
  r.state = "BC"
  r.save!

  t = Tax.new
  t.name = "gst_bc"
  t.shorthand = "GST"
  t.percentage = 5
  t.regional_subscription = r
  t.save!

  t2 = Tax.new
  t2.name = "pst_bc"
  t2.shorthand = "PST"
  t2.percentage = 8
  t2.regional_subscription = r
  t2.save!
end