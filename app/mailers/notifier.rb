class Notifier < ActionMailer::Base
  default from: 'Libreunir <soporte@libreunir.com>'

  def remind(reminder)
    @reminder = reminder

    mail to: @reminder.user_email
  end
end
