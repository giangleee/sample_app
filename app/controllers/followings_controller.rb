class FollowingsController < ApplicationController
  before_action :logged_in_user, :find_user, only: :index

  def index
    @title = t("following").capitalize
    @users = @user.following.paginate(page: params[:page])
    render "show_follow", status: :unprocessable_entity
  end
end
