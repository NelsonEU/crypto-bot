class NotificationsMailer < ApplicationMailer
  def alert(recurring_alert, user)
    @username = user.username.present? ? user.username : user.email

    @total_value = recurring_alert.last_value
    @alerts = recurring_alert.recurring_alert_lines.sort { |a, b| b.variation <=> a.variation }
    @currency = user.default_currency.downcase == 'eur' ? '€' : '$'

    mail(to: user.email, subject: 'Recurring prices notification')
  end
end
