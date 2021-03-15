class AlertJob < ApplicationJob
  def perform
    ::AlertService.create_alerts
  end
end
