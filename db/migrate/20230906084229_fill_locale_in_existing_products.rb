class FillLocaleInExistingProducts < ActiveRecord::Migration[7.0]
  def up
    Product.update_all(locale: 'en')
  end

  def down
    Product.update_all(locale: nil)
  end
end
