class ErrorMailer < ApplicationMailer
  default from: email_address_with_name('linolium.91@mail.com', 'Hikaru Book Store ')

  def app_failed(error, request_info)
    @error = error
    @request = request_info
    admin_email = 'dark_sao@mail.ru'
    mail to: admin_email, subject: 'Hikaru Book Store have errors!'
  end
end