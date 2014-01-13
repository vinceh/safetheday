class UsersController < ApplicationController
  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :check_new

  def account
    if current_user.regional_subscription
      @sub = current_user.regional_subscription
      @stripe_customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
    end
  end

  def payment
    @user = current_user
  end

  def history
    @invoices = current_user.invoices.order('created_at DESC').where("invoices.amount > 0")
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

    feed = Feedback.new

    if params[:cancel][:feedback] == "Other"
      feed.description = params[:cancel][:text_feedback]
    else
      feed.description = params[:cancel][:feedback]
    end

    feed.member_since = current_user.created_at
    feed.subscription = current_user.subscription.name
    feed.save!

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
    sub = current_user.change_subscription(params[:sub])

    flash[:notice] = "Subscription updated!  You will receive a box of #{sub.name} in your next shipment."
    redirect_to :action => :account
  end

  def change_interval
    region_sub = current_user.change_interval

    flash[:notice] = "Subscription updated!  You will receive a box every #{region_sub.interval_words}"
    redirect_to :action => :account
  end

  def referrals
    @user = current_user
  end
end
