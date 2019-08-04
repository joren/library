class Mailer < ActionMailer::Base
  default from: 'books@joren.gent'
  layout 'mailer'

  def user_login_requested(user)
    @user = user

    mail(to: @user.email, subject: 'Books login requested')
  end

  def user_welcome(user)
    @user = user

    mail(to: @user.email, subject: "Welcome to our books library")
  end
end
