class SessionsController < ApplicationController
  before_action :find_user, only: [:create]

  def new; end

  def create
    reset_session
    if @user&.authenticate(params[:session][:password])
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      log_in @user
      redirect_to @user
    else
      flash.now[:danger] = I18n.t "users.create.session.failed"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end

  private

  def find_user
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user.is_a? NilClass
      flash.now[:danger] = I18n.t "users.show.user_not_found"
    else
      @user = user
    end
  end
end
