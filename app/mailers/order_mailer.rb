class OrderMailer < ApplicationMailer
  default from: email_address_with_name('linolium.91@mail.com', 'Hikaru Book Store ')

  def received(order)
    @order = order
    file_path = File.join(Rails.root, 'app', 'assets', 'images' ,'book_word.jpg')
    attachments.inline['book_word.jpg'] = File.read file_path

    mail to: order.email, subject: 'Hikaru Book Store Order Confirmation'
  end
  
  def shipped(order)
    @order = order

    mail to: order.email, subject: 'Hikaru Book Store Order Shipped'
  end

  def failed(order)
    @order = order

    mail to: order.email, subject: 'Hikaru Book Store Order Failed'
  end
end
