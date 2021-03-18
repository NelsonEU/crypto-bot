class RecurringAlertLine < ApplicationRecord
  belongs_to :coin
  belongs_to :recurring_alert

  def value
    price * coin.quantity
  end
end
