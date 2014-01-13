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

      if session[:referral] && Time.now <= Time.at(session[:referral_timeout])
        referrer = User.find_by_referral_code(session[:referral])
        referrer.give_free_month

        UserMailer.free_month(referrer, @user)

        session[:referral] = nil
        session[:referral_timeout] = nil
      end
    end
  end
end
