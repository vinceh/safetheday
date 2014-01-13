class UserMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default from: "c.tnecniv@gmail.com"

  def subscribed(user)
    @user = user
    mail(:to => @user.email, :subject => "Your Safe Subscription")
  end

  def invoice(user, invoice)
    @user = user
    @invoice = invoice
    mail(:to => @user.email, :subject => "Your Safe Subscription")
  end

  def free_month(referrer, friend)
    @referrer = referrer
    @friend = friend
    mail(:to => @referrer.email, :subject => "Good on Ya")
  end
end
