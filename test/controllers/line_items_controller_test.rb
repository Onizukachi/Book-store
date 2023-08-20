require "test_helper"

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_item = line_items(:one)
    @line_item_with_quantity_1 = line_items(:five)
  end

  test "should get index" do
    get line_items_url
    assert_response :success
  end

  test "should get new" do
    get new_line_item_url
    assert_response :success
  end

  test "should create line_item" do
    assert_difference("LineItem.count") do
      post line_items_url, params: { product_id: products(:ruby).id }
    end

    follow_redirect!

    assert_select 'h2', 'Your Cart'
    assert_select 'td', "Programming Ruby 1.9"
    assert_select 'td', "1"
  end

  test "should create line_item via turbo-streams" do
    assert_difference("LineItem.count") do
      post line_items_url, params: { product_id: products(:ruby).id },
        as: :turbo_stream
    end

    assert_response :success
    assert_match /<tr.+?class=line-item-highlight>/, @response.body
  end

  test "should update only quantity in line item when added same product" do 
    2.times do
      post line_items_url, params: { product_id: products(:ruby).id }
    end

    assert_no_difference("LineItem.count") do
      post line_items_url, params: { product_id: products(:ruby).id }
    end

    follow_redirect!

    assert_select 'h2', 'Your Cart'
    assert_select 'td', "Programming Ruby 1.9"
    assert_select 'td', "3"
  end

  test "should show line_item" do
    get line_item_url(@line_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_item_url(@line_item)
    assert_response :success
  end

  test "should update line_item" do
    patch line_item_url(@line_item), params: { line_item: { product_id: @line_item.product_id } }
    assert_redirected_to line_item_url(@line_item)
  end

  test "should decrease line_item quanitity from cart" do
    assert_difference('@line_item.reload.quantity', -1) do
      delete line_item_url(@line_item)
    end
    
    assert_redirected_to store_index_path
  end

  test "should destroy line_item from cart" do
    delete line_item_url(@line_item_with_quantity_1)
    assert_nil LineItem.find_by(id: @line_item_with_quantity_1.id)
    assert_redirected_to store_index_path
  end
end
