namespace :reminders do
  desc 'Send email reminders'
  task send: :environment do
    ::Reminder.send_reminders
  end
end
