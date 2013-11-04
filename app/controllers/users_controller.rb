class UsersController < ApplicationController
  protect_from_forgery

  before_filter :authenticate_user!

  def account

  end

  def address
    @user = current_user
  end
end
