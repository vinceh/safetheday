class Tax < ActiveRecord::Base
  attr_accessible :shorthand, :percentage, :country, :state
end