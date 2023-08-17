class RemoveProductPriceFromLineIteem < ActiveRecord::Migration[7.0]
  def change
    remove_column :line_items, :product_price
  end
end
