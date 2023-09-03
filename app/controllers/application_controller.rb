class ApplicationController < ActionController::Base
  rescue_from Exception, with: :send_mail_to_admin

  before_action :set_i18n_locale_from_params
  before_action :authorize

  protected

  def set_i18n_locale_from_params
    if params[:locale]
      if I18n.available_locales.map(&:to_s).include?(params[:locale])
        I18n.locale = params[:locale]
      else
        flash.now[:notice] = "#{params[:locale]} translation not available"
        logger.error flash.now[:notice]
      end
    end
  end

  private

  def send_mail_to_admin(exception)
    error = exception.inspect
    request_info = request.inspect
    ErrorMailer.app_failed(error, request_info).deliver_later

    raise Exception
  end

  def authorize
    unless User.find_by(id: session[:user_id])
      redirect_to login_url, notice: "Please Log in"
    end
  end
end
