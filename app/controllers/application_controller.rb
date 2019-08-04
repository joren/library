class ApplicationController < ActionController::Base
  before_action :login_required

  def login_required
    return redirect_to([:new, :authentication], notice: "Please login in first") unless user_logged_in?
  end

  def user_logged_in?
    !!current_user
  end

  def current_user
    return nil unless session[:current_user_id]
    @current_user ||= User.find(session[:current_user_id])
  end
end
