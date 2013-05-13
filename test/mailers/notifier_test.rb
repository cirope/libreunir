require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  test 'remind' do
    reminder = Fabricate(:reminder)
    mail = Notifier.remind(reminder)

    assert_equal I18n.t('notifier.remind.subject'), mail.subject
    assert_equal [reminder.user_email], mail.to
    assert_equal ['soporte@libreunir.com'], mail.from
    assert_match reminder.description, mail.body.encoded

    assert_difference 'ActionMailer::Base.deliveries.size' do
      mail.deliver
    end
  end
end
