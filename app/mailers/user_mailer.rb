class UserMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default from: "Safe"

  def subscribed(user, request)
    @user = user
    @sub = @user.regional_subscription
    @request = request
    mail(:to => @user.email, :subject => "Welcome to Safe")
  end

  def invoice(user, invoice)
    @user = user
    @invoice = invoice
    @sub = @user.regional_subscription
    mail(:to => @user.email, :subject => "Your Safe Subscription")
  end

  def free_month(referrer, friend, request)
    @user = referrer
    @friend = friend
    @request = request
    mail(:to => @user.email, :subject => "Good on Ya")
  end
end
