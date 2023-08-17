class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def add_product(product)
    current_item = line_items.find_by(product_id: product.id)
  
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(product_id: product.id)
    end

    current_item
  end

  def destroy_or_decrease_quantity(line_item)
    check = self.line_items.include?(line_item)
    if check && line_item.quantity > 1
       line_item.update(quantity: line_item.quantity - 1)
    elsif check
       line_item.destroy
    end
  end
  
  def total_price
    line_items.sum(&:total_price)
  end
end
