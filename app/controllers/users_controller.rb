class UsersController < ApplicationController
  before_action :set_user

  def show
  end

  def update
    @user.update(user_params)
    flash[:notice] = t("user.settings.saved")
    redirect_to action: :show
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:notify_book_read, :notify_book_downloaded, :notify_book_uploaded)
  end
end
