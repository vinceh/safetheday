class UserMailer < ActionMailer::Base
  default from: "c.tnecniv@gmail.com"

  def subscribed(user)
    @user = user
    mail(:to => @user.email, :subject => "Your Safe Subscription")
  end
end
