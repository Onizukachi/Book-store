#require 'active_model/serializers/xml'
require 'pago'

class Order < ApplicationRecord
  include ActiveModel::Serializers::Xml

  before_update :send_notification_when_shipped, if: :ship_date_updated?

  enum pay_type: {
    "Check" => 0,
    "Credit card" => 1,
    "Purchase order" => 2 
  }

  has_many :line_items, dependent: :destroy

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

  def charge!(pay_type_params)
    payment_details = {}
    payment_method = nil

    case pay_type
    when "Check"
      payment_method = :check
      payment_details[:routing] = pay_type_params[:routing_number]
      payment_details[:account] = pay_type_params[:account_number]
    when "Credit card"
      payment_method = :credit_card
      month, year = pay_type_params[:expiration_date].split(/\//)
      payment_details[:cc_num] = pay_type_params[:credit_card_number]
      payment_details[:expiration_month] = month
      payment_details[:expiration_year] = year
    when "Purchase order"
      payment_method = :po
      payment_details[:po_num] = pay_type_params[:po_number]
    end

    payment_result = Pago.make_payment(
      order_id: id,
      payment_method: payment_method,
      payment_details: payment_details  
    )

    if payment_result.succeeded?
      OrderMailer.received(self).deliver_later
    else
      raise payment_result.error
    end
  end

  private
  
  def credit_card_payment?
    pay_type == 'Credit card'
  end

  def ship_date_updated?
    ship_date_changed?
  end

  def send_notification_when_shipped
    ShipOrderJob.perform_later(self)
  end
end


