class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      if session[:cart]
        checkout_path
      else
        select_pack_path
      end
    elsif resource.is_a?(Admin)
      admin_root_path
    end
  end

  def select_pack
    if current_user.subscription_id
      redirect_to user_root_path
    elsif !session[:cart]
      redirect_to select_pack_path
    end
  end

  def no_sub
    if current_user && current_user.subscription_id
      redirect_to user_root_path
    end
  end
end
