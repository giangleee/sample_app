class PasswordResetsController < ApplicationController
  before_action :find_user_base_email, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params.dig(:password_reset, :email)&.downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "email_sent_with_password_reset_instructions"
      redirect_to root_url
    else
      flash.now[:danger] = t "email_address_not_found"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if params.dig(:user, :password)&.empty?
      @user.errors.add(:password, t("can_not_be_empty"))
      render :edit, status: :unprocessable_entity
    elsif @user.update(user_params) # Case 4
      reset_session
      log_in @user
      @user.update_column :reset_digest, nil
      flash[:success] = t "password_has_been_reset"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity # Case 2
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # Confirms a valid user.
  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    redirect_to :root, flash: {warning: t("account_activation")}
  end

  # Checks expiration of reset token.
  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "password_has_been_reset"
    redirect_to new_password_reset_url
  end
end
