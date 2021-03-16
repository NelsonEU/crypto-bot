desc "alerts scheduler"
task recurring_alerts: :environment do
  puts "Sending recurring alerts..."
  RecurringAlertsJob.perform_now
  puts "Alerts sent!"
end
