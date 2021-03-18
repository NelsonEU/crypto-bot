class User < ApplicationRecord
  has_many :coins
  has_many :recurring_alerts

  def last_recurring_alert
    return nil if recurring_alerts.empty?

    recurring_alerts.order(created_at: :desc).first
  end
end
