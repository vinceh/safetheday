class UsersController < ApplicationController
  protect_from_forgery

  before_filter :authenticate_user!

  def account

  end

  def payment
    @user = current_user

    if request.post?
      @user = current_user
      @user.update_attributes(params[:user])

      if @user.valid? && @user.update_payment(params[:stripeToken])
        flash[:success] = "Your payment and shipping settings have been updated!"
        redirect_to user_payment_path
      else
        flash[:error] = "There was an error updating your payment and shipping settings"
        redirect_to user_payment_path
      end
    end
  end
end
