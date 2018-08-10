require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

#  def setup
#  end

  def reveal_cart
    visit store_index_url
    
    first('.catalog li').click_on 'Add to Cart'

    assert_selector "#cart .line-item-highlight"
  end

  def common_scenario
    reveal_cart

    click_on 'Checkout'

    fill_in 'order_name', with: 'Chris Otta'
    fill_in 'order_address', with: 'Lolwe Drive'
    fill_in 'order_email', with: 'email@example.com'
  end

  def clear_orders_in_test_db
    LineItem.delete_all
    Order.delete_all
  end

  def queue_job_with_generic_form_details
    perform_enqueued_jobs do
      click_button "Place order"
    end

    @orders = Order.all
    assert_equal 1, @orders.size
    @order = @orders.first

    assert_equal "Chris Otta", @order.name
    assert_equal "Lolwe Drive", @order.address
    assert_equal "email@example.com", @order.email
  end


  def send_mail
    mail = ActionMailer::Base::deliveries.last
    assert_equal ["email@example.com"], mail.to
    assert_equal 'Chris Otta <otta.chris@me.com>', mail[:from].value
    assert_equal "My Favorite Store Order Confirmation", mail.subject
  end

  test "check routing number" do
    clear_orders_in_test_db

    common_scenario
    assert_no_selector "#order_routing_number"
    assert_no_selector "#order_account_number"

    select 'Check', from: 'pay_type'

    assert_selector "#order_routing_number"
    assert_selector "#order_account_number"

    fill_in "Routing #", with: "123456"
    fill_in "Account #", with: "987654"

    queue_job_with_generic_form_details

    assert_equal "Check", @order.pay_type
    assert_equal 1, @order.line_items.size

    send_mail
  end

  test "check purchase order number" do
    clear_orders_in_test_db

    common_scenario

    assert_no_selector "#order_po_number"

    select 'Purchase order', from: 'pay_type'

    assert_selector "#order_po_number"

    fill_in "PO #", with: "123456"

    queue_job_with_generic_form_details

    assert_equal "Purchase order", @order.pay_type
    assert_equal 1, @order.line_items.size

    send_mail
  end

  test "check credit card number and expiration date" do
    clear_orders_in_test_db

    common_scenario

    assert_no_selector "#order_credit_card_number"
    assert_no_selector "#order_expiration_date"

    select 'Credit card', from: 'pay_type'

    assert_selector "#order_credit_card_number"
    assert_selector "#order_expiration_date"

    queue_job_with_generic_form_details

    assert_equal "Credit card", @order.pay_type
    assert_equal 1, @order.line_items.size

    send_mail
  end

  test "reveal cart on product addition" do
    reveal_cart
  end
  
  test "hide cart when emptied" do
    reveal_cart
    
    click_on 'Empty cart'

    page.driver.browser.switch_to.alert.accept rescue Selenium::WebDriver::Error::NoAlertPresentError

    assert_no_selector "#cart"
  end
end
