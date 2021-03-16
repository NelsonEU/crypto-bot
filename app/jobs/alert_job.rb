class AlertJob < ApplicationJob
  def perform
    ::AlertService.send_alerts
  end
end
