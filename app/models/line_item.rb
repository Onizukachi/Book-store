class LineItem < ApplicationRecord
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :product
  belongs_to :cart

  def total_price
    quantity * product.price
  end
end
