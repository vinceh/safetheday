class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :check_omni, :only => [:edit, :update]
end