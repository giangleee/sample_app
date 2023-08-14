class AccountActivationsController < ApplicationController
  before_action :find_user_base_email, only: :edit

  def edit
    if !@user&.activated? && @user&.authenticated?(:activation, params[:id])
      @user.activate
      log_in @user
      flash[:success] = t "user_mailer.account_activation.subject"
      redirect_to @user
    else
      flash[:danger] = t "user_mailer.account_activation.fail"
      redirect_to root_url
    end
  end

  private

  def find_user_base_email
    @user = User.find_by email: params[:email]

    return if @user
    redirect_to :root,
                flash: {warning: t("users.show.user_not_found")}
  end
end
