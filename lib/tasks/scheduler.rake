task :admin => :environment do
  puts "Creating admin..."

  newuser = Admin.new({ :email => 'admin@safetheday.com',
                        :password => 'Mspudding5611',
                        :password_confirmation => 'Mspudding5611'})
  newuser.save!

  puts "Done"
end

task :convert_shipments => :environment do
  puts "Converting current invoices to shipments..."

  invoices = Invoice.where("amount > 0 or free_month = true")

  invoices.each do |i|
    p = PendingShipment.new
    p.invoice = i
    p.shipped_on = i.shipped_on
    p.ship_start_date = i.created_at
    p.save!

    invoice = Stripe::Invoice.retrieve(i.stripe_invoice_id)
    if invoice.lines.data[0].quantity == 2
      p = PendingShipment.new
      p.invoice = i
      p.shipped_on = i.shipped_on
      p.ship_start_date = i.created_at + 15.days
      p.save!
    end
  end

  puts "Done"
end

task :clean_tables => :environment do
  puts "Cleaning out Taxes table..."
  Tax.destroy_all

  puts "Cleaning out Subscriptions table..."
  Subscription.destroy_all

  puts "Done"
end

task :delete_stripe_data => :environment do
  coupons = Stripe::Coupon.all
  plans = Stripe::Plan.all

  puts "Deleting coupons..."

  coupons.data.each do |c|
    c.delete
  end

  puts "Deleting plans..."

  plans.data.each do |p|
    p.delete
  end
end

task :stripe_seed => :environment do
  # Create the subscriptions on Stripe
  Stripe.api_key = ENV['SECRET_KEY']

  puts "Creating Stripe Plans..."
  # Canada
  Stripe::Plan.create(
    :amount => 900,
    :interval => 'month',
    :name => 'Regular Canada',
    :currency => 'cad',
    :id => 'reg_ca'
  )

  Stripe::Plan.create(
    :amount => 1500,
    :interval => 'month',
    :name => 'Premium Canada',
    :currency => 'cad',
    :id => 'prem_ca'
  )

  # US
  Stripe::Plan.create(
    :amount => 900,
    :interval => 'month',
    :name => 'Regular US',
    :currency => 'usd',
    :id => 'reg_us'
  )

  Stripe::Plan.create(
    :amount => 1500,
    :interval => 'month',
    :name => 'Premium US',
    :currency => 'usd',
    :id => 'prem_us'
  )

  puts "Plans created"
end

task :sub_database_seed => :environment do
  # The overarching subscription objects

  puts "Creating subscriptions..."
  Subscription.create(name: "The Wingman",
                      description: "8 Durex Sensi Thin, 1 Okamoto 0.03L Condom",
                      price: "900",
                      shorthand: "wing",
                      stripe: "reg")

  Subscription.create(name: "The Connoisseur",
                      description: "9 Okamoto 0.03L Condoms",
                      price: "1500",
                      shorthand: "conno",
                      stripe: "prem")

  puts "Creating taxes..."
  # Taxes for all states

  # Canada
  # AB, NU, YT, NT, MB, SK
  Tax.create(shorthand: "GST",
             percentage: "5",
             country: "CA",
             state: "AB")

  Tax.create(shorthand: "GST",
             percentage: "5",
             country: "CA",
             state: "NU")

  Tax.create(shorthand: "GST",
             percentage: "5",
             country: "CA",
             state: "YT")

  Tax.create(shorthand: "GST",
             percentage: "5",
             country: "CA",
             state: "NT")

  Tax.create(shorthand: "GST",
             percentage: "5",
             country: "CA",
             state: "MB")

  Tax.create(shorthand: "GST",
             percentage: "5",
             country: "CA",
             state: "SK")

  # BC
  Tax.create(shorthand: "GST",
             percentage: "5",
             country: "CA",
             state: "BC")

  Tax.create(shorthand: "PST",
             percentage: "7",
             country: "CA",
             state: "BC")

  # NB, NL, ON
  Tax.create(shorthand: "GST",
             percentage: "5",
             country: "CA",
             state: "NB")

  Tax.create(shorthand: "PST",
             percentage: "8",
             country: "CA",
             state: "NB")

  Tax.create(shorthand: "GST",
             percentage: "5",
             country: "CA",
             state: "NL")

  Tax.create(shorthand: "PST",
             percentage: "8",
             country: "CA",
             state: "NL")

  Tax.create(shorthand: "GST",
             percentage: "5",
             country: "CA",
             state: "ON")

  Tax.create(shorthand: "PST",
             percentage: "8",
             country: "CA",
             state: "ON")

  # PE
  Tax.create(shorthand: "GST",
             percentage: "5",
             country: "CA",
             state: "PE")

  Tax.create(shorthand: "PST",
             percentage: "9",
             country: "CA",
             state: "PE")

  # NS
  Tax.create(shorthand: "GST",
             percentage: "5",
             country: "CA",
             state: "NS")

  Tax.create(shorthand: "PST",
             percentage: "10",
             country: "CA",
             state: "NS")

  puts "Done"
end

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