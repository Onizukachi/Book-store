class CartsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "carts"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def update_cart(data)
    cart_id = data['cart_id']
    return unless cart_id

    cart = Cart.find(cart_id[/(?<=cart_)\d+/])
    return unless cart
    
    cart.broadcast_replace_later_to 'carts', partial: 'layouts/cart'
  end
end
