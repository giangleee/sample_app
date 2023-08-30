class FollowersController < ApplicationController
  before_action :logged_in_user, :find_user, only: :index

  def index
    @title = t("followers").capitalize
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow", status: :unprocessable_entity
  end
end
