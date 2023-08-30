require "application_system_test_case"

class ProductsTest < ApplicationSystemTestCase
  setup do
    @product = products(:one)
  end

  test "visiting the index" do
    visit products_url
    assert_selector "h1", text: "Products"
  end

  test "should create product" do
    visit products_url
    click_on "New Product"

    fill_in "Description", with: 'New product'
    fill_in "Image url", with: @product.image_url
    fill_in "Price", with: '22.12'
    fill_in "Title", with: 'Spider Man Comics'
    click_on "Create Product"

    assert_text "Product was successfully created"
  end

  test "should update Product" do
    visit product_url(@product)
    click_on "Edit this product", match: :first

    fill_in "Description", with: 'This product was updated'
    fill_in "Image url", with: @product.image_url
    fill_in "Price", with: @product.price
    fill_in "Title", with: @product.title
    click_on "Update Product"

    assert_text "Product was successfully updated"
  end

  test "cant destroy Product if included in any line_items" do
    visit product_url(@product)
    click_on "Destroy this product", match: :first

    assert_text "Product cant be destroyed!"
  end
end
