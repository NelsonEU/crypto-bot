require "test_helper"

class NotificationsMailerTest < ActionMailer::TestCase
  test "alert" do
    mail = NotificationsMailer.alert
    assert_equal "Alert", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
