task :admin => :environment do
  newuser = Admin.new({ :email => 'admin@safetheday.com',
                        :password => 'Mspudding5611',
                        :password_confirmation => 'Mspudding5611'})
  newuser.save!
end

task :stripe_seed => :environment do
  # Create the subscriptions on Stripe
  Stripe.api_key = ENV['SECRET_KEY']

  # ==============
  # MONTHLY REGULAR PLANS
  # ==============

  # 5% tax
  Stripe::Plan.create(
    :amount => 1260,
    :interval => 'month',
    :name => '5% Regular Canada Monthly',
    :currency => 'cad',
    :id => 'reg_5_ca'
  )

  # 12% tax
  Stripe::Plan.create(
    :amount => 1344,
    :interval => 'month',
    :name => '12% Regular Canada Monthly',
    :currency => 'cad',
    :id => 'reg_12_ca'
  )

  # 13% tax
  Stripe::Plan.create(
    :amount => 1356,
    :interval => 'month',
    :name => '13% Regular Canada Monthly',
    :currency => 'cad',
    :id => 'reg_13_ca'
  )

  # 14% tax
  Stripe::Plan.create(
    :amount => 1368,
    :interval => 'month',
    :name => '14% Regular Canada Monthly',
    :currency => 'cad',
    :id => 'reg_14_ca'
  )

  # 15% tax
  Stripe::Plan.create(
    :amount => 1380,
    :interval => 'month',
    :name => '15% Regular Canada Monthly',
    :currency => 'cad',
    :id => 'reg_15_ca'
  )

  # ==============
  # BI-WEEKLY REGULAR PLANS
  # ==============

  # 5% tax
  Stripe::Plan.create(
    :amount => 1260,
    :interval => 'week',
    :interval_count => '2',
    :name => '5% Regular Canada Bi-Weekly',
    :currency => 'cad',
    :id => 'reg_5_ca_bi'
  )

  # 12% tax
  Stripe::Plan.create(
    :amount => 1344,
    :interval => 'week',
    :interval_count => '2',
    :name => '12% Regular Canada Bi-Weekly',
    :currency => 'cad',
    :id => 'reg_12_ca_bi'
  )

  # 13% tax
  Stripe::Plan.create(
    :amount => 1356,
    :interval => 'week',
    :interval_count => '2',
    :name => '13% Regular Canada Bi-Weekly',
    :currency => 'cad',
    :id => 'reg_13_ca_bi'
  )

  # 14% tax
  Stripe::Plan.create(
    :amount => 1368,
    :interval => 'week',
    :interval_count => '2',
    :name => '14% Regular Canada Bi-Weekly',
    :currency => 'cad',
    :id => 'reg_14_ca_bi'
  )

  # 15% tax
  Stripe::Plan.create(
    :amount => 1380,
    :interval => 'week',
    :interval_count => '2',
    :name => '15% Regular Canada Bi-Weekly',
    :currency => 'cad',
    :id => 'reg_15_ca_bi'
  )

  # ==============
  # MONTHLY PREMIUM PLANS
  # ==============

  # 5% tax
  Stripe::Plan.create(
    :amount => 2100,
    :interval => 'month',
    :name => '5% Premium Canada Monthly',
    :currency => 'cad',
    :id => 'pre_5_ca'
  )

  # 12% tax
  Stripe::Plan.create(
    :amount => 2240,
    :interval => 'month',
    :name => '12% Premium Canada Monthly',
    :currency => 'cad',
    :id => 'pre_12_ca'
  )

  # 13% tax
  Stripe::Plan.create(
    :amount => 2260,
    :interval => 'month',
    :name => '13% Premium Canada Monthly',
    :currency => 'cad',
    :id => 'pre_13_ca'
  )

  # 14% tax
  Stripe::Plan.create(
    :amount => 2280,
    :interval => 'month',
    :name => '14% Premium Canada Monthly',
    :currency => 'cad',
    :id => 'pre_14_ca'
  )

  # 15% tax
  Stripe::Plan.create(
    :amount => 2300,
    :interval => 'month',
    :name => '15% Premium Canada Monthly',
    :currency => 'cad',
    :id => 'pre_15_ca'
  )

  # ==============
  # BI-WEEKLY PREMIUM PLANS
  # ==============

  # 5% tax
  Stripe::Plan.create(
    :amount => 2100,
    :interval => 'week',
    :interval_count => '2',
    :name => '5% Premium Canada Bi-Weekly',
    :currency => 'cad',
    :id => 'pre_5_ca_bi'
  )

  # 12% tax
  Stripe::Plan.create(
    :amount => 2240,
    :interval => 'week',
    :interval_count => '2',
    :name => '12% Premium Canada Bi-Weekly',
    :currency => 'cad',
    :id => 'pre_12_ca_bi'
  )

  # 13% tax
  Stripe::Plan.create(
    :amount => 2260,
    :interval => 'week',
    :interval_count => '2',
    :name => '13% Premium Canada Bi-Weekly',
    :currency => 'cad',
    :id => 'pre_13_ca_bi'
  )

  # 14% tax
  Stripe::Plan.create(
    :amount => 2280,
    :interval => 'week',
    :interval_count => '2',
    :name => '14% Premium Canada Bi-Weekly',
    :currency => 'cad',
    :id => 'pre_14_ca_bi'
  )

  # 15% tax
  Stripe::Plan.create(
    :amount => 2300,
    :interval => 'week',
    :interval_count => '2',
    :name => '15% Premium Canada Bi-Weekly',
    :currency => 'cad',
    :id => 'pre_15_ca_bi'
  )
end

task :sub_database_seed => :environment do

  # The overarching subscription objects
  reg = Subscription.create(name: "The Wingman",
                            description: "8 Durex Sensi Thin, 1 Okamoto 0.03L Condoms",
                            price: "1200",
                            shorthand: "wing")

  pre = Subscription.create(name: "The Connoisseur",
                            description: "9 Okamoto 0.03L Condoms",
                            price: "2000",
                            shorthand: "conno")

  # Regional Subscription + Taxes for every subscription

  # ==============
  # MONTHLY REGULAR PLANS
  # ==============

  # 5% tax
  # AB, NU, YT, NT, MB, SK
  reg_ca_ab = RegionalSubscription.create(stripe_subscription_id: "reg_5_ca",
                                          subscription: reg,
                                          state: "AB")
  Tax.create(name: "reg_gst_ab",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_ab)

  reg_ca_nu = RegionalSubscription.create(stripe_subscription_id: "reg_5_ca",
                                          subscription: reg,
                                          state: "NU")
  Tax.create(name: "reg_gst_nu",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_nu)

  reg_ca_yt = RegionalSubscription.create(stripe_subscription_id: "reg_5_ca",
                                          subscription: reg,
                                          state: "YT")
  Tax.create(name: "reg_gst_yt",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_yt)

  reg_ca_nt = RegionalSubscription.create(stripe_subscription_id: "reg_5_ca",
                                          subscription: reg,
                                          state: "NT")
  Tax.create(name: "reg_gst_nt",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_nt)

  reg_ca_mb = RegionalSubscription.create(stripe_subscription_id: "reg_5_ca",
                                          subscription: reg,
                                          state: "MB")
  Tax.create(name: "reg_gst_mb",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_mb)

  reg_ca_sk = RegionalSubscription.create(stripe_subscription_id: "reg_5_ca",
                                          subscription: reg,
                                          state: "SK")
  Tax.create(name: "reg_gst_sk",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_sk)

  # 12% tax
  # BC
  reg_ca_bc = RegionalSubscription.create(stripe_subscription_id: "reg_12_ca",
                                          subscription: reg,
                                          state: "BC")
  Tax.create(name: "reg_gst_bc",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_bc)
  Tax.create(name: "reg_pst_bc",
             shorthand: "PST",
             percentage: "7",
             regional_subscription: reg_ca_bc)

  # 13% tax
  # NB, NL, ON
  reg_ca_nb = RegionalSubscription.create(stripe_subscription_id: "reg_13_ca",
                                          subscription: reg,
                                          state: "NB")
  Tax.create(name: "reg_gst_nb",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_nb)
  Tax.create(name: "reg_pst_nb",
             shorthand: "PST",
             percentage: "8",
             regional_subscription: reg_ca_nb)

  reg_ca_nl = RegionalSubscription.create(stripe_subscription_id: "reg_13_ca",
                                          subscription: reg,
                                          state: "NL")
  Tax.create(name: "reg_gst_nl",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_nl)
  Tax.create(name: "reg_pst_nl",
             shorthand: "PST",
             percentage: "8",
             regional_subscription: reg_ca_nl)

  reg_ca_on = RegionalSubscription.create(stripe_subscription_id: "reg_13_ca",
                                          subscription: reg,
                                          state: "ON")
  Tax.create(name: "reg_gst_on",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_on)
  Tax.create(name: "reg_pst_on",
             shorthand: "PST",
             percentage: "8",
             regional_subscription: reg_ca_on)

  # 14% tax
  # PE
  reg_ca_pe = RegionalSubscription.create(stripe_subscription_id: "reg_14_ca",
                                          subscription: reg,
                                          state: "PE")
  Tax.create(name: "reg_gst_pe",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_pe)
  Tax.create(name: "reg_pst_pe",
             shorthand: "PST",
             percentage: "9",
             regional_subscription: reg_ca_pe)

  # 15% tax
  # NS
  reg_ca_ns = RegionalSubscription.create(stripe_subscription_id: "reg_15_ca",
                                          subscription: reg,
                                          state: "NS")
  Tax.create(name: "reg_gst_ns",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_ns)
  Tax.create(name: "reg_pst_ns",
             shorthand: "PST",
             percentage: "10",
             regional_subscription: reg_ca_ns)

  # ==============
  # BI-WEEKLY REGULAR PLANS
  # ==============

  # 5% tax
  # AB, NU, YT, NT, MB, SK
  reg_ca_ab_bi = RegionalSubscription.create(stripe_subscription_id: "reg_5_ca_bi",
                                          subscription: reg,
                                          state: "AB")
  Tax.create(name: "reg_gst_ab_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_ab_bi)

  reg_ca_nu_bi = RegionalSubscription.create(stripe_subscription_id: "reg_5_ca_bi",
                                          subscription: reg,
                                          state: "NU")
  Tax.create(name: "reg_gst_nu_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_nu_bi)

  reg_ca_yt_bi = RegionalSubscription.create(stripe_subscription_id: "reg_5_ca_bi",
                                          subscription: reg,
                                          state: "YT")
  Tax.create(name: "reg_gst_yt_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_yt_bi)

  reg_ca_nt_bi = RegionalSubscription.create(stripe_subscription_id: "reg_5_ca_bi",
                                          subscription: reg,
                                          state: "NT")
  Tax.create(name: "reg_gst_nt_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_nt_bi)

  reg_ca_mb_bi = RegionalSubscription.create(stripe_subscription_id: "reg_5_ca_bi",
                                          subscription: reg,
                                          state: "MB")
  Tax.create(name: "reg_gst_mb_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_mb_bi)

  reg_ca_sk_bi = RegionalSubscription.create(stripe_subscription_id: "reg_5_ca_bi",
                                          subscription: reg,
                                          state: "SK")
  Tax.create(name: "reg_gst_sk_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_sk_bi)

  # 12% tax
  # BC
  reg_ca_bc_bi = RegionalSubscription.create(stripe_subscription_id: "reg_12_ca_bi",
                                          subscription: reg,
                                          state: "BC")
  Tax.create(name: "reg_gst_bc_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_bc_bi)
  Tax.create(name: "reg_pst_bc_bi",
             shorthand: "PST",
             percentage: "7",
             regional_subscription: reg_ca_bc_bi)


  # 13% tax
  # NB, NL, ON
  reg_ca_nb_bi = RegionalSubscription.create(stripe_subscription_id: "reg_13_ca_bi",
                                          subscription: reg,
                                          state: "NB")
  Tax.create(name: "reg_gst_nb_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_nb_bi)
  Tax.create(name: "reg_pst_nb_bi",
             shorthand: "PST",
             percentage: "8",
             regional_subscription: reg_ca_nb_bi)

  reg_ca_nl_bi = RegionalSubscription.create(stripe_subscription_id: "reg_13_ca_bi",
                                          subscription: reg,
                                          state: "NL")
  Tax.create(name: "reg_gst_nl_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_nl_bi)
  Tax.create(name: "reg_pst_nb_bi",
             shorthand: "PST",
             percentage: "8",
             regional_subscription: reg_ca_nl_bi)

  reg_ca_on_bi = RegionalSubscription.create(stripe_subscription_id: "reg_13_ca_bi",
                                          subscription: reg,
                                          state: "ON")
  Tax.create(name: "reg_gst_on_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_on_bi)
  Tax.create(name: "reg_pst_on_bi",
             shorthand: "PST",
             percentage: "8",
             regional_subscription: reg_ca_on_bi)

  # 14% tax
  # PE
  reg_ca_pe_bi = RegionalSubscription.create(stripe_subscription_id: "reg_14_ca_bi",
                                          subscription: reg,
                                          state: "PE")
  Tax.create(name: "reg_gst_pe_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_pe_bi)
  Tax.create(name: "reg_pst_pe_bi",
             shorthand: "PST",
             percentage: "9",
             regional_subscription: reg_ca_pe_bi)

  # 15% tax
  # NS
  reg_ca_ns_bi = RegionalSubscription.create(stripe_subscription_id: "reg_15_ca_bi",
                                          subscription: reg,
                                          state: "NS")
  Tax.create(name: "reg_gst_ns_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: reg_ca_ns_bi)
  Tax.create(name: "reg_pst_ns_bi",
             shorthand: "PST",
             percentage: "10",
             regional_subscription: reg_ca_ns_bi)

  # ==============
  # MONTHLY PREMIUM PLANS
  # ==============

  # 5% tax
  # AB, NU, YT, NT, MB, SK
  pre_ca_ab = RegionalSubscription.create(stripe_subscription_id: "pre_5_ca",
                                          subscription: pre,
                                          state: "AB")
  Tax.create(name: "pre_gst_ab",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_ab)

  pre_ca_nu = RegionalSubscription.create(stripe_subscription_id: "pre_5_ca",
                                          subscription: pre,
                                          state: "NU")
  Tax.create(name: "pre_gst_nu",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_nu)

  pre_ca_yt = RegionalSubscription.create(stripe_subscription_id: "pre_5_ca",
                                          subscription: pre,
                                          state: "YT")
  Tax.create(name: "pre_gst_yt",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_yt)

  pre_ca_nt = RegionalSubscription.create(stripe_subscription_id: "pre_5_ca",
                                          subscription: pre,
                                          state: "NT")
  Tax.create(name: "pre_gst_nt",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_nt)

  pre_ca_mb = RegionalSubscription.create(stripe_subscription_id: "pre_5_ca",
                                          subscription: pre,
                                          state: "MB")
  Tax.create(name: "pre_gst_mb",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_mb)

  pre_ca_sk = RegionalSubscription.create(stripe_subscription_id: "pre_5_ca",
                                          subscription: pre,
                                          state: "SK")
  Tax.create(name: "pre_pst_sk",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_sk)


  # 12% tax
  # BC
  pre_ca_bc = RegionalSubscription.create(stripe_subscription_id: "pre_12_ca",
                                          subscription: pre,
                                          state: "BC")
  Tax.create(name: "pre_gst_bc",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_bc)
  Tax.create(name: "pre_pst_bc",
             shorthand: "PST",
             percentage: "7",
             regional_subscription: pre_ca_bc)

  # 13% tax
  # NB, NL, ON
  pre_ca_nb = RegionalSubscription.create(stripe_subscription_id: "pre_13_ca",
                                          subscription: pre,
                                          state: "NB")
  Tax.create(name: "pre_gst_nb",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_nb)
  Tax.create(name: "pre_pst_nb",
             shorthand: "PST",
             percentage: "8",
             regional_subscription: pre_ca_nb)

  pre_ca_nl = RegionalSubscription.create(stripe_subscription_id: "pre_13_ca",
                                          subscription: pre,
                                          state: "NL")
  Tax.create(name: "pre_gst_nl",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_nl)
  Tax.create(name: "pre_pst_nl",
             shorthand: "PST",
             percentage: "8",
             regional_subscription: pre_ca_nl)

  pre_ca_on = RegionalSubscription.create(stripe_subscription_id: "pre_13_ca",
                                          subscription: pre,
                                          state: "ON")
  Tax.create(name: "pre_gst_on",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_on)
  Tax.create(name: "pre_pst_on",
             shorthand: "PST",
             percentage: "8",
             regional_subscription: pre_ca_on)

  # 14% tax
  # PE
  pre_ca_pe = RegionalSubscription.create(stripe_subscription_id: "pre_14_ca",
                                          subscription: pre,
                                          state: "PE")
  Tax.create(name: "pre_gst_pe",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_pe)
  Tax.create(name: "pre_pst_pe",
             shorthand: "PST",
             percentage: "9",
             regional_subscription: pre_ca_pe)

  # 15% tax
  # NS
  pre_ca_ns = RegionalSubscription.create(stripe_subscription_id: "pre_15_ca",
                                          subscription: pre,
                                          state: "NS")
  Tax.create(name: "pre_gst_ns",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_ns)
  Tax.create(name: "pre_pst_ns",
             shorthand: "PST",
             percentage: "10",
             regional_subscription: pre_ca_ns)

  # ==============
  # BI-WEEKLY PREMIUM PLANS
  # ==============

  # 5% tax
  # AB, NU, YT, NT, MB, SK
  pre_ca_ab_bi = RegionalSubscription.create(stripe_subscription_id: "pre_5_ca_bi",
                                          subscription: pre,
                                          state: "AB")
  Tax.create(name: "pre_gst_ab_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_ab_bi)

  pre_ca_nu_bi = RegionalSubscription.create(stripe_subscription_id: "pre_5_ca_bi",
                                          subscription: pre,
                                          state: "NU")
  Tax.create(name: "pre_gst_nu_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_nu_bi)

  pre_ca_yt_bi = RegionalSubscription.create(stripe_subscription_id: "pre_5_ca_bi",
                                          subscription: pre,
                                          state: "YT")
  Tax.create(name: "pre_gst_yt_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_yt_bi)

  pre_ca_nt_bi = RegionalSubscription.create(stripe_subscription_id: "pre_5_ca_bi",
                                          subscription: pre,
                                          state: "NT")
  Tax.create(name: "pre_gst_nt_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_nt_bi)

  pre_ca_mb_bi = RegionalSubscription.create(stripe_subscription_id: "pre_5_ca_bi",
                                          subscription: pre,
                                          state: "MB")
  Tax.create(name: "pre_gst_mb_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_mb_bi)

  pre_ca_sk_bi = RegionalSubscription.create(stripe_subscription_id: "pre_5_ca_bi",
                                          subscription: pre,
                                          state: "SK")
  Tax.create(name: "pre_gst_sk_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_sk_bi)

  # 12% tax
  # BC
  pre_ca_bc_bi = RegionalSubscription.create(stripe_subscription_id: "pre_12_ca_bi",
                                          subscription: pre,
                                          state: "BC")
  Tax.create(name: "pre_gst_bc_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_bc_bi)
  Tax.create(name: "pre_pst_bc_bi",
             shorthand: "PST",
             percentage: "7",
             regional_subscription: pre_ca_bc_bi)

  # 13% tax
  # NB, NL, ON
  pre_ca_nb_bi = RegionalSubscription.create(stripe_subscription_id: "pre_13_ca_bi",
                                          subscription: pre,
                                          state: "NB")
  Tax.create(name: "pre_gst_nb_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_nb_bi)
  Tax.create(name: "pre_pst_nb_bi",
             shorthand: "PST",
             percentage: "8",
             regional_subscription: pre_ca_nb_bi)

  pre_ca_nl_bi = RegionalSubscription.create(stripe_subscription_id: "pre_13_ca_bi",
                                          subscription: pre,
                                          state: "NL")
  Tax.create(name: "pre_gst_nl_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_nl_bi)
  Tax.create(name: "pre_pst_nl_bi",
             shorthand: "PST",
             percentage: "8",
             regional_subscription: pre_ca_nl_bi)

  pre_ca_on_bi = RegionalSubscription.create(stripe_subscription_id: "pre_13_ca_bi",
                                          subscription: pre,
                                          state: "ON")
  Tax.create(name: "pre_gst_on_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_on_bi)
  Tax.create(name: "pre_pst_on_bi",
             shorthand: "PST",
             percentage: "8",
             regional_subscription: pre_ca_on_bi)

  # 14% tax
  # PE
  pre_ca_pe_bi = RegionalSubscription.create(stripe_subscription_id: "pre_14_ca_bi",
                                          subscription: pre,
                                          state: "PE")
  Tax.create(name: "pre_gst_pe_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_pe_bi)
  Tax.create(name: "pre_pst_pe_bi",
             shorthand: "PST",
             percentage: "9",
             regional_subscription: pre_ca_pe_bi)

  # 15% tax
  # NS
  pre_ca_ns_bi = RegionalSubscription.create(stripe_subscription_id: "pre_15_ca_bi",
                                          subscription: pre,
                                          state: "NS")
  Tax.create(name: "pre_gst_ns_bi",
             shorthand: "GST",
             percentage: "5",
             regional_subscription: pre_ca_ns_bi)
  Tax.create(name: "pre_pst_ns_bi",
             shorthand: "PST",
             percentage: "10",
             regional_subscription: pre_ca_ns_bi)


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