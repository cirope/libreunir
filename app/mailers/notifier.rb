class Notifier < ActionMailer::Base
  default from: 'Libreunir <soporte@libreunir.com>'

  def remind(reminder)
    @reminder = reminder

    mail to: @reminder.user_email
  end

  def summary(user)
    @schedules = user.schedules.today

    mail to: user.email
  end
end
