class Notifier < ActionMailer::Base
  include MandrillHeaders

  default from: 'Libreunir <soporte@libreunir.com>'

  def remind(reminder)
    @reminder = reminder

    mail to: @reminder.user_email
  end

  def summary(user)
    @user = user
    @schedules = user.schedules.for_tomorrow

    mail to: user.email
  end
end
