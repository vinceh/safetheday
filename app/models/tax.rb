class Tax < ActiveRecord::Base

  belongs_to :regional_subscription

  attr_accessible :shorthand, :percentage, :country, :state
end