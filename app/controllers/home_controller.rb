class HomeController < ApplicationController
  protect_from_forgery

  before_filter :no_sub, :only => [:add_pack, :select_pack]

  def select_pack
    @subs = Subscription.all
  end

  def add_pack
    session[:cart] = params[:pack]

    redirect_to new_user_session_path
  end
end
