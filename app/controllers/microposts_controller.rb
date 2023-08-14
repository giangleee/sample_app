class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params

    if save_micropost
      flash[:success] = t("micropost_created").capitalize
      redirect_to root_url
    else
      handle_failed_creation
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t("micropost_deleted").capitalize
    else
      flash[:danger] = t("deleted_fail").capitalize
    end
    redirect_to (request.referer || root_path), status: :see_other
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t("micropost_invalid").capitalize
    redirect_to (request.referer || root_path), status: :see_other
  end

  def handle_failed_creation
    @feed_items = current_user.feed.paginate(page: params[:page])
    render "static_pages/home", status: :unprocessable_entity
  end

  def save_micropost
    @micropost.image.attach(params[:micropost][:image])
    @micropost.save
  end
end
