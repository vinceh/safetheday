class RegionalSubscription < ActiveRecord::Base

  belongs_to :user
  belongs_to :subscription
  has_many :taxes, :class_name => 'Tax'

  attr_accessor :stripe_object_singleton

  def name
    subscription.name
  end

  def description
    subscription.description
  end

  def stripe_object
    if !@stripe_object_singleton
      @stripe_object_singleton = Stripe::Plan.retrieve(stripe_subscription_id)
    end
    return @stripe_object_singleton
  end

  def interval_words
    stripe_object.interval_count.to_s + " " + stripe_object.interval.capitalize+(stripe_object.interval_count > 1 ? "s" : "" )
  end

  def fee
    stripe_object.amount
  end

  def untaxed_amount
    subscription.price
  end

  def currency
    stripe_object.currency.upcase
  end
end