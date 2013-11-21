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