class UsersController < ApplicationController
  protect_from_forgery

  before_filter :authenticate_user!

  def account
    @sub = current_user.subscription_id
    @stripe_customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
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
end
