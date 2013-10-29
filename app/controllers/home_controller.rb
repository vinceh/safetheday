class HomeController < ApplicationController
  protect_from_forgery

  def select_pack

  end

  def add_pack
    session[:cart] = params[:pack]

    redirect_to new_user_session_path
  end
end
