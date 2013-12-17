class PaymentsController < ApplicationController
  protect_from_forgery

  before_filter :select_pack, :only => [:checkout]
  before_filter :authenticate_user!

  def checkout
    @user = current_user

    if request.post?
      @user = current_user
      @user.update_attributes(params[:user])
      sub = Subscription.find(params[:subscription])

      if @user.valid? && sub && @user.create_subscription(sub, params[:stripeToken])
        redirect_to user_root_path
      else
        redirect_to root_url
      end
    end
  end
end
