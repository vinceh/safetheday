class HomeController < ApplicationController
  protect_from_forgery

  before_filter :no_sub, :only => [:add_pack, :select_pack]

  def index
    render :layout => "home_layout"
  end

  def select_pack
    @subs = Subscription.all
    session[:referral] = params[:ref] if params[:ref]
    session[:referral_timeout] = (Time.now+1.hour).to_i if params[:ref]
  end

  def add_pack
    session[:cart] = params[:pack]
    redirect_to new_user_registration_path
  end


end
