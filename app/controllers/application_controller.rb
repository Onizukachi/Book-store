class ApplicationController < ActionController::Base
  rescue_from Exception, with: :send_mail_to_admin

  before_action :authorize

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
