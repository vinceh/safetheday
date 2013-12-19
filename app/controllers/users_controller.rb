class UsersController < ApplicationController
  protect_from_forgery

  before_filter :authenticate_user!

  def account
    @sub = current_user.regional_subscription
    @stripe_customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
  end

  def payment
    @user = current_user
  end

  def history
    @invoices = current_user.invoices.order('created_at DESC')
  end

  def invoice
    @invoice = current_user.get_invoice(params[:id])
    @charge = Stripe::Charge.retrieve(@invoice.stripe_charge_id)
    @stripe_invoice = Stripe::Invoice.retrieve(@invoice.stripe_invoice_id)

    unless @invoice
      redirect_to root_path
    end

    render :layout => "layouts/invoice"
  end

  def unsubscribe
    current_user.unsubscribe

    redirect_to user_root_path
  end

  def update_shipping
    @user = current_user
    @user.update_attributes(params[:user])

    flash[:success] = "Shipping address updated!  Your next box will be shipped to your new address."

    redirect_to :action => :payment
  end

  def update_payment
    @user = current_user
    @user.update_attributes(params[:user])

    if @user.valid? && @user.update_payment(params[:stripeToken])

      flash[:success] = "Credit Card Updated!  Your next box will be charged to your new Credit Card."
      redirect_to :action => :payment
    end
  end

  def change_subscription
    flash[:notice] = params[:sub]
    redirect_to :action => :account
  end
end
