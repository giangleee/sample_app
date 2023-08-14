class SessionsController < ApplicationController
  before_action :find_user_base_session, only: :create

  def new; end

  def create
    reset_session
    if @user.activated?
      activate_user_create @user
    else
      flash.now[:danger] = t "user_mailer.account_activation.invalid"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end

  private

  def find_user_base_session
    @user = User.find_by email: params.dig(:session, :email)&.downcase
    return if @user

    flash[:danger] = t "users.show.user_not_found"
    redirect_to action: :new
  end
end
