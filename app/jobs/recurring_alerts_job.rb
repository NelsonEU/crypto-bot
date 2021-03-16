class RecurringAlertsJob < ApplicationJob
  def perform
    ::AlertService.send_alerts
  end
end
