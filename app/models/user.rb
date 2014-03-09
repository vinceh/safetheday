class User < ActiveRecord::Base
  has_many :invoices
  belongs_to :subscription
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook]

  attr_accessible :email, :password, :password_confirmation, :remember_me, :stripe_customer_id, :stripe_customer_id, :billing_first_name, :billing_last_name, :billing_address_one,
                  :billing_city, :billing_state, :billing_country, :billing_zipcode, :billing_phone, :shipping_same,
                  :subscription_id, :shipping_first_name, :shipping_last_name, :shipping_address_one, :shipping_city,
                  :shipping_state, :shipping_country, :shipping_zipcode, :shipping_phone, :billing_address_two, :shipping_address_two

  before_create :create_referral_code

  attr_accessor :stripe_object_singleton

  def stripe_object
    if !@stripe_object_singleton
      @stripe_object_singleton = Stripe::Customer.retrieve(stripe_customer_id)
    end
    return @stripe_object_singleton
  end

  def create_subscription(subscription, stripe_token, quantity, coupon_id = nil)
    self.subscription = subscription

    begin
      if billing_country == "CA"
        stripe_plan = self.subscription.stripe + "_ca"
      else
        stripe_plan = self.subscription.stripe + "_us"
      end

      discount = discount_for_coupon(coupon_id)
      tax = calculate_tax - discount[0]
      tax = (tax * (1-discount[1].to_f/100)).round
      tax = tax * quantity

      if billing_country == "CA"
        customer = Stripe::Customer.create(
          :card  => stripe_token,
          :plan => stripe_plan,
          :email => self.email,
          :account_balance => tax,
          :coupon => coupon_id,
          :quantity => quantity
        )
      else
        customer = Stripe::Customer.create(
          :card  => stripe_token,
          :plan => stripe_plan,
          :email => self.email,
          :coupon => coupon_id,
          :quantity => quantity
        )
      end



      self.stripe_customer_id = customer.id
      self.plan_ending_date = Time.at(customer.subscriptions.data[0].current_period_end)

      token = Stripe::Token.retrieve(stripe_token)
      self.card_last_four = token.card.last4
      self.card_type = token.card.type
      self.inactive = false
      save

      true
    rescue Stripe::CardError => e
      nil
    end
  end

  def delivery_interval
    if current_quantity == 1
      return "Monthly"
    else
      return "2 Weeks"
    end
  end

  def current_quantity
    stripe_object.subscriptions.data[0].quantity
  end

  def next_bill_date_in_words
    (Time.at(stripe_object.subscriptions.data[0].current_period_end)+1.day).strftime("%b %d, %Y")
  end

  def full_price
    (subscription.price + calculate_tax)*current_quantity
  end

  def change_subscription(sub)
    self.subscription = sub

    begin
      if billing_country == "CA"
        stripe_plan = self.subscription.stripe + "_ca"
      else
        stripe_plan = self.subscription.stripe + "_us"
      end

      customer = Stripe::Customer.retrieve(self.stripe_customer_id)
      customer.update_subscription(:plan => stripe_plan,
                                   :prorate => false,
                                   :quantity => stripe_object.subscriptions.data[0].quantity)

      save

      return self.subscription
    rescue Stripe::CardError => e
      nil
    end
  end

  def update_payment(stripe_token)
    begin
      customer = Stripe::Customer.retrieve(self.stripe_customer_id)
      customer.card = stripe_token
      customer.save

      token = Stripe::Token.retrieve(stripe_token)
      self.card_last_four = token.card.last4
      self.card_type = token.card.type

      save

      true
    rescue Stripe::CardError => e
      nil
    end
  end

  def get_invoice(id)
    self.invoices.find(id)
  end

  def unsubscribe
    self.inactive = true
    self.referral_code = nil
    if save!
      cu = Stripe::Customer.retrieve(stripe_customer_id)
      cu.cancel_subscription
    end
  end

  def is_monthly?
    stripe_object.subscriptions.data[0].quantity == 1
  end

  def change_interval
    begin
      stripe_object.update_subscription(:plan => current_plan_id,
                                        :prorate => false,
                                        :quantity => (is_monthly? && 2) || 1 )

      true
    rescue Stripe::CardError => e
      nil
    end
  end

  def current_plan_id
    stripe_object.subscriptions.data[0].plan.id
  end

  def give_free_month
    # total amount of free months this user has earned
    self.total_free_months = self.total_free_months + 1

    # attempt to add a free month via Stripe coupon
    # if user already has a coupon, add it to the current_free_months
    if !add_stripe_free_month
      self.current_free_months = self.current_free_months + 1
    end

    save!
  end

  def give_pending_free_month
    self.current_free_months = self.current_free_months - 1
    add_stripe_free_month
    save!
  end

  def total_fee
    (self.subscription.price + calculate_tax) * current_quantity
  end

  def currency
    stripe_object.currency
  end

  def add_stripe_free_month
    customer = stripe_object

    if !customer.discount
      if self.billing_country == "CA"
        coupon = "free_month_ca"
      else
        coupon = "free_month_us"
      end

      customer.coupon = coupon
      customer.save
      return true
    else
      return false
    end
  end

  def full_name
    if self.shipping_same
      self.billing_first_name + " " + self.billing_last_name
    else
      self.shipping_first_name + " " + self.shipping_last_name
    end
  end

  def self.find_for_facebook_oauth(auth)
    user = self.find_by_email(auth.info.email)

    if !user
      user = where(auth.slice(:provider, :uid)).first
      unless user
        user = User.new
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.save!
      end

      return user
    elsif user.provider && user.uid
      return where(auth.slice(:provider, :uid)).first
    else
      user.provider = auth.provider
      user.uid = auth.uid
      user.save!
    end
  end

  def calculate_tax
    total = 0

    taxes.each do |t|
      total = total + (self.subscription.price * (t.percentage.to_f / 100)).round
    end

    return total
  end

  def taxes
    Tax.where(country: self.billing_country, state: self.billing_state).all
  end

  protected

  def create_referral_code
    self.referral_code = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.exists?(referral_code: random_token)
    end
  end

  private

  def discount_for_coupon(coupon_id)
    discount = [0,0]

    begin
      c = Stripe::Coupon.retrieve(coupon_id)

      if c.valid
        discount[0] = c.amount_off || 0
        discount[1] = c.percent_off || 0
      end
    rescue
    end

    discount
  end
end
