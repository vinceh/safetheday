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

  def create_subscription(subscription, stripe_token)
    self.subscription = subscription

    begin
      if shipping_country == "CA"
        stripe_plan = self.subscription.stripe + "_ca"
      else
        stripe_plan = self.subscription.stripe + "_us"
      end

      customer = Stripe::Customer.create(
        :card  => stripe_token,
        :plan => stripe_plan,
        :email => self.email,
        :account_balance => calculate_tax
      )

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
    if stripe_object.subscriptions.data[0].quantity = 1
      return "Monthly"
    else
      return "2 Weeks"
    end
  end

  def next_bill_date_in_words
    (Time.at(stripe_object.subscriptions.data[0].current_period_end)+1.day).strftime("%b %d, %Y")
  end

  def full_price
    subscription.price + calculate_tax
  end

  def change_subscription(sub)
    self.subscription = sub

    begin
      if shipping_country == "CA"
        stripe_plan = self.subscription.stripe + "_ca"
      else
        stripe_plan = self.subscription.stripe + "_us"
      end

      customer = Stripe::Customer.retrieve(self.stripe_customer_id)
      customer.update_subscription(:plan => stripe_plan,
                                   :prorate => false,
                                   :quantity => stripe_object.subscriptions.data[0].quantity)

      save

      true
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

  # really hackish way of doing this
  # but if the stripe_subscription_id doesn't end in _bi then it's monthly
  def is_monthly?
    stripe_object.subscriptions.data[0].quantity == 1
  end

  def change_interval
    customer.update_subscription(:plan => stripe_plan,
                                 :prorate => false,
                                 :quantity => (is_monthly? && 2) || 1 )
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

  def add_stripe_free_month
    customer = Stripe::Customer.retrieve(self.stripe_customer_id)

    if !customer.discount
      customer.coupon = "free_month"
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
end
