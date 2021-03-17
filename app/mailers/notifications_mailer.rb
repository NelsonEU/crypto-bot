class NotificationsMailer < ApplicationMailer
  def alert(alerts, user)
    @username = user.username.present? ? user.username : user.email
    @alerts = alerts.sort { |a, b| b.variation <=> a.variation }
    @currency = user.default_currency.downcase == 'eur' ? '€' : '$'

    mail(to: user.email, subject: 'Recurring prices notification')
  end
end
