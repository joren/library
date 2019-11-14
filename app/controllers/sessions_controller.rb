class SessionsController < ApplicationController
  skip_before_action :login_required
  def create
    user = User.find_by(auth_token: params[:auth_token])
    if user && user.auth_token_expires_at > Time.zone.now
      session[:current_user_id] = user.id
      redirect_to :root, notice: "Ingelogd"
    else
      redirect_to [:new, :authentication], notice: "Vraag even een nieuwe login aan."
    end
  end

  def destroy
    session[:current_user_id] = nil
    redirect_to :root, notice: "Uitgelogd"
  end
end
