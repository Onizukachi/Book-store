class TransferProductPriceFromProductsToLineItems < ActiveRecord::Migration[7.0]
  def up
    Product.all.each do |product|
      LineItem.where(product_id: product.id).update_all(product_price: product.price)
    end
  end

  def down
    LineItem.update_all(product_price: nil)
  end
end
