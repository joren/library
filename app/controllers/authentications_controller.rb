class AuthenticationsController < ApplicationController
  skip_before_action :login_required

  def new
  end

  def create
    if params[:email].present?
      user = User.find_by(email: params[:email])
      if user
        user.generate_auth_token
        user.save!
        Mailer.user_login_requested(user).deliver_now
      end
      redirect_to [:new, :authentication], notice: "Er is een email onderweg met daarin een link om in te loggen."
    else
      flash[:error] = "Gelieve een geldig email adres in te geven"
      redirect_to [:new, :authentication]
    end
  end
end
