class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy
  enum pay_type: {
    "Check" => 0,
    "Credit card" => 1,
    "Purchase order" => 2 
  }

  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: pay_types.keys

  with_options if: :credit_card_payment? do |credit_card|
    credit_card.validates :credit_card_number, :expiration_date, presence: true
    credit_card.validates :expiration_date, format: { with: /\A\d{2}\/\d{2}\Z/, message: "Expiration date should be like 04/24" }
  end

  validates :routing_number, :account_number, presence: true, if: -> { pay_type == 'Check' }

  validates :po_number, presence: true, if: -> { pay_type == 'Purchase order' }

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  private
  
  def credit_card_payment?
    pay_type == 'Credit card'
  end
end


