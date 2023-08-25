require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  test "check order and delivery" do
    LineItem.delete_all
    Order.delete_all

    visit store_index_url

    click_on 'Add to Cart', match: :first

    click_on 'Checkout'

    fill_in 'Name', with: 'Alexey Glazkov'
    fill_in 'Address', with: 'Alasheevka 149'
    fill_in 'Email', with: 'dark_sao@mail.ru'

    select 'Check', from: 'Pay type'
    fill_in 'Routing number', with: '123456'
    fill_in 'Account number', with: '9867654'

    click_button "Place Order"
    assert_text 'Thank you for your order'

    perform_enqueued_jobs 
    perform_enqueued_jobs
    assert_performed_jobs 2

    orders = Order.all
    assert_equal 1, orders.size

    order = Order.first
    assert_equal 'Alexey Glazkov', order.name
    assert_equal 'Alasheevka 149', order.address
    assert_equal 'dark_sao@mail.ru', order.email
    assert_equal 'Check', order.pay_type
    assert_equal 1, order.line_items.size

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dark_sao@mail.ru"], mail.to
    assert_equal ["linolium.91@mail.com"], mail.from
    assert_equal "Hikaru Book Store Order Confirmation", mail.subject
    
  end
end
