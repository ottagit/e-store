require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  test "received" do
    mail = OrderMailer.received(orders(:one))
    assert_equal "My Favorite Store Order Confirmation", mail.subject
    assert_equal ["email@example.com"], mail.to
    assert_equal ["otta.chris@me.com"], mail.from
    assert_match /1 x The 4-Hour Work Week/, mail.body.encoded
  end

  test "shipped" do
    mail = OrderMailer.shipped(orders(:one))
    assert_equal "Your Favorite Store Order Shipped", mail.subject
    assert_equal ["email@example.com"], mail.to
    assert_equal ["otta.chris@me.com"], mail.from
    assert_match /<td[^>]*>1<\/td>\s*<td>The 4-Hour Work Week<\/td>/, mail.body.encoded
  end

end
