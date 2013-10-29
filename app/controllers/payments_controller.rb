class PaymentsController < ApplicationController
  protect_from_forgery

  before_filter :select_pack, :only => [:checkout]
  before_filter :authenticate_user!

  def checkout
    @user = current_user
  end
end
