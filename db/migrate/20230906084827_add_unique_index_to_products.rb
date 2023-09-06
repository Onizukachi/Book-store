class AddUniqueIndexToProducts < ActiveRecord::Migration[7.0]
  def change
    add_index :products, [:title, :locale], unique: true
  end
end
