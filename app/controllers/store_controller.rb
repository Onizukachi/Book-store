class StoreController < ApplicationController
  include CurrentCart
  skip_before_action :authorize
  before_action :set_cart, only: %i[index]

  def index
    if params[:set_locale]
      redirect_to store_index_url(locale: params[:set_locale])
    else
      @products = Product.order(:title)
      CartsChannel.broadcast_to('carts', { event: 'product_updated' })
    end
  end
end
