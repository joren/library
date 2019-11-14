class ApplicationController < ActionController::Base
  before_action :login_required

  def login_required
    return redirect_to([:new, :authentication], notice: "Gelieve eerst in te loggen") unless user_logged_in?
  end

  def user_logged_in?
    !!current_user
  end
  helper_method :user_logged_in?

  def current_user
    return nil unless session[:current_user_id]
    @current_user ||= User.find(session[:current_user_id])
  end
  helper_method :current_user
end
