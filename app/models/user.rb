class User < ActiveRecord::Base

  has_many :invoices
  belongs_to :regional_subscription
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :stripe_customer_id, :stripe_customer_id, :billing_first_name, :billing_last_name, :billing_address_one,
                  :billing_city, :billing_state, :billing_country, :billing_zipcode, :billing_phone, :shipping_same,
                  :subscription_id, :shipping_first_name, :shipping_last_name, :shipping_address_one, :shipping_city,
                  :shipping_state, :shipping_country, :shipping_zipcode, :shipping_phone, :billing_address_two, :shipping_address_two

  def create_subscription(subscription, stripe_token)
    self.regional_subscription = RegionalSubscription
                                    .where(state: billing_state,
                                           subscription_id: subscription.id).first

    begin
      customer = Stripe::Customer.create(
        :card  => stripe_token,
        :plan => self.regional_subscription.stripe_subscription_id,
        :email => self.email
      )

      self.stripe_customer_id = customer.id
      self.plan_ending_date = Time.at(customer.subscription.current_period_end)

      token = Stripe::Token.retrieve(stripe_token)
      self.card_last_four = token.card.last4
      self.card_type = token.card.type
      save

      true
    rescue Stripe::CardError => e
      nil
    end
  end

  def subscription
    regional_subscription.subscription
  end

  def change_subscription(sub)
    sub = Subscription.find_by_shorthand(sub)
    self.regional_subscription = RegionalSubscription.where(state: billing_state,
                                                            subscription_id: sub.id).first

    begin
      customer = Stripe::Customer.retrieve(self.stripe_customer_id)
      customer.update_subscription(:plan => self.regional_subscription.stripe_subscription_id,
                                   :prorate => false)

      save

      return sub
    rescue Stripe::CardError => e
      nil
    end
  end

  def update_payment(stripe_token)
    self.regional_subscription = RegionalSubscription
                                    .where(state: billing_state,
                                           subscription_id: self.regional_subscription.subscription_id).first

    begin
      customer = Stripe::Customer.retrieve(self.stripe_customer_id)
      customer.update_subscription(:plan => self.regional_subscription.stripe_subscription_id,
                                   :prorate => false,
                                   :card => stripe_token)

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
    self.regional_subscription_id = nil
    if save!
      cu = Stripe::Customer.retrieve(stripe_customer_id)
      cu.cancel_subscription
    end
  end

  # really hackish way of doing this
  # but if the stripe_subscription_id doesn't end in _bi then it's monthly
  def is_monthly?
    !regional_subscription.stripe_subscription_id.include?('bi')
  end

  def change_interval
    current = regional_subscription.stripe_subscription_id

    if is_monthly?
      current = current + "_bi"
    else
      current.slice!("_bi")
    end

    self.regional_subscription = RegionalSubscription.where(stripe_subscription_id: current).first

    begin
      customer = Stripe::Customer.retrieve(self.stripe_customer_id)
      customer.update_subscription(:plan => self.regional_subscription.stripe_subscription_id,
                                   :prorate => false,
                                   :trial_end => customer.subscription.current_period_end)

      save

      return self.regional_subscription
    rescue Stripe::CardError => e
      nil
    end
  end
end
