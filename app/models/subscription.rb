class Subscription < ActiveRecord::Base

  has_many :regional_subscriptions

  attr_accessible :name, :description, :price, :shorthand, :stripe

end