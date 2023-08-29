class StoreController < ApplicationController
  include CurrentCart
  skip_before_action :authorize
  before_action :set_cart, only: %i[index]

  def index
    @products = Product.order(:title)
    CartsChannel.broadcast_to('carts', { event: 'product_updated' })
  end
end
