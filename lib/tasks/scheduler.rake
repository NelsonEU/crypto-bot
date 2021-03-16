desc "alerts scheduler"
task recurring_alerts: :environment do
  puts "Sending recurring alerts..."
  ::RecurringAlertsService.send
  puts "Alerts sent!"
end
