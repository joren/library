class Mailer < ActionMailer::Base
  default from: 'books@joren.gent'
  layout 'mailer'

  def user_login_requested(user)
    @user = user

    mail(to: @user.email, subject: 'Login link voor onze bibliotheek.')
  end

  def user_welcome(user)
    @user = user

    mail(to: @user.email, subject: "Hoera! Toegang voor onze gedeelde bibliotheek")
  end
end
