class ApplicationController < ActionController::Base
  rescue_from Exception, with: :send_mail_to_admin

  private

  def send_mail_to_admin(exception)
    error = exception.inspect
    request_info = request.inspect
    ErrorMailer.app_failed(error, request_info).deliver_later

    raise Exception
  end
end
