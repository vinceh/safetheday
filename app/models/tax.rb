class Tax < ActiveRecord::Base

  belongs_to :regional_subscription

  attr_accessible :name, :shorthand, :percentage, :regional_subscription
end