class RecurringAlert < ApplicationRecord
  belongs_to :user

  has_many :recurring_alert_lines

  def last_value
    recurring_alert_lines.map(&:value).reduce(:+)
  end
end
