s = Subscription.new
s.name = "The Adventurer"
s.description = "Luxury Condoms"
s.price = 1599
s.shorthand = "adv"
s.save!

r = RegionalSubscription.new
r.subscription = s
r.stripe_subscription_id = "24_ca"
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
s.shorthand = "jour"
s.save!

r = RegionalSubscription.new
r.subscription = s
r.stripe_subscription_id = "12_ca"
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
