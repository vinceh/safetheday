class PaymentsController < ApplicationController
  protect_from_forgery

  before_filter :select_pack, :only => [:checkout]
  before_filter :authenticate_user!

  def checkout
    @user = current_user
    @sub = Subscription.find_by_shorthand(session[:cart])
    @quantity = session[:quantity].to_i

    if request.post?
      @user = current_user
      @user.update_attributes(params[:user])
      sub = Subscription.find_by_shorthand(params[:subscription])
      quantity = params[:quantity].to_i

      if quantity < 1 || quantity > 2
        redirect_to root_url
      end

      if @user.valid? && sub && @user.create_subscription(sub, params[:stripeToken], quantity)
        if session[:referral] && Time.now <= Time.at(session[:referral_timeout])
          referrer = User.find_by_referral_code(session[:referral])
          referrer.give_free_month
          UserMailer.free_month(referrer, @user, request).deliver

          session[:referral] = nil
          session[:referral_timeout] = nil
        end

        redirect_to user_root_path
      else
        redirect_to root_url
      end
    end
  end
end
