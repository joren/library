class AuthenticationsController < ApplicationController
  skip_before_action :login_required

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user
      user.generate_auth_token
      user.save!
      Mailer.user_login_requested(user).deliver_now
    end
    redirect_to [:new, :authentication], notice: "We have send you an email with a link to log back in."
  end
end
