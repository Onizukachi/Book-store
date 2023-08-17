class RemoveTotalPriceFromLineItems < ActiveRecord::Migration[7.0]
  def change
    remove_column :line_items, :total_price
  end
end
