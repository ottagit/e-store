require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase

  def common_scenario
    visit store_index_url

    first('.catalog li').click_on 'Add to Cart'

    click_on 'Checkout'

    fill_in 'order_name', with: 'Chris Otta'
    fill_in 'order_address', with: 'Lolwe Drive'
    fill_in 'order_email', with: 'email@example.com'
  end

  def reveal_cart
    visit store_index_url
    
    first('.catalog li').click_on 'Add to Cart'

    assert_selector "#cart .line-item-highlight"
  end

  test "check routing number" do
    common_scenario
    assert_no_selector "#order_routing_number"

    select 'Check', from: 'pay_type'

    assert_selector "#order_routing_number"
  end

  test "check purchase order number" do
    common_scenario

    assert_no_selector "#order_po_number"

    select 'Purchase order', from: 'pay_type'

    assert_selector "#order_po_number"
  end

  test "check credit card number and expiration date" do
    common_scenario

    assert_no_selector "#order_credit_card_number"
    assert_no_selector "#order_expiration_date"

    select 'Credit card', from: 'pay_type'

    assert_selector "#order_credit_card_number"
    assert_selector "#order_expiration_date"
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
