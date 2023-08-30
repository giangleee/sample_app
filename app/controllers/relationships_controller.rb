class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    if @user
      redirect_to :root, flash: {warning: t("users.show.user_not_found").capitalize}
    end
    current_user.follow @user
    respond_to do |format|
      format.html {redirect_to @user}
      format.turbo_stream
    end
    redirect_to (request.referer || root_path), status: :see_other
  end

  def destroy
    @user = Relationship.find_by(id: params[:id])&.followed
    if @user
      redirect_to :root, flash: {warning: t("users.show.user_not_found").capitalize}
    end
    current_user.unfollow(@user)
    respond_to do |format|
      format.html {redirect_to @user, status: :see_other}
      format.turbo_stream
    end
    redirect_to (request.referer || root_path), status: :see_other
  end
end
