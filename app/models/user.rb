class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :stripe_customer_id, :stripe_customer_id, :billing_first_name, :billing_last_name, :billing_address_one,
                  :billing_city, :billing_state, :billing_country, :billing_zipcode, :billing_phone, :shipping_same,
                  :subscription_id, :shipping_first_name, :shipping_last_name, :shipping_address_one, :shipping_city,
                  :shipping_state, :shipping_country, :shipping_zipcode, :shipping_phone, :billing_address_two, :shipping_address_two

  validates_presence_of :billing_first_name, :billing_last_name, :billing_address_one,
                        :billing_city, :billing_state, :billing_country, :billing_zipcode, :billing_phone
  validates_presence_of :shipping_first_name, :shipping_last_name, :shipping_address_one, :shipping_city,
                        :shipping_state, :shipping_country, :shipping_zipcode, :shipping_phone, :unless => :shipping_same

  def create_subscription(subscription, stripe_token)
    self.subscription_id = subscription

    begin
      customer = Stripe::Customer.create(
        :card  => stripe_token,
        :plan => self.subscription_id,
        :email => self.email
      )

      self.stripe_customer_id = customer.id
      self.plan_ending_date = Time.at(customer.subscription.current_period_end)
      save

      UserMailer.subscribed(self).deliver
      true
    rescue Stripe::CardError => e
      nil
    end

  end
end
