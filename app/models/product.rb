class Product < ApplicationRecord
  has_many :line_items

  RUBLE_EXCHANGE_RATE = 95.0

  #after_update_commit -> { broadcast_prepend_to "products", partial: "products/product", locals: { quote: self }, target: "products" }

  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, :locale, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, uniqueness: { scope: :locale }

  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }

  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, 'Line Items present')
      throw :abort
    end
  end

  def price_depends_on_locale
    if I18n.locale.to_s == 'ru'
      price * RUBLE_EXCHANGE_RATE
    else
      price
    end
  end
end
