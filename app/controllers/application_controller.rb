class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend
  before_action :set_locale

  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "users.log_in.success"
    redirect_to login_url, status: :see_other
  end

  private

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = if I18n.available_locales.include?(locale)
                    locale
                  else
                    I18n.default_locale
                  end
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def find_user_base_email
    @user = User.find_by email: params[:email]

    return if @user

    redirect_to :root,
                flash: {warning: t("users.show.user_not_found")}
  end
end
