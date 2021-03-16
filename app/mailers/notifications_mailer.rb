class NotificationsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications_mailer.alert.subject
  #
  def alert(alerts, user)
    @username = user.username.present? ? user.username : user.email
    @alerts = alerts.sort { |a, b| b.variation <=> a.variation }
    @currency = user.default_currency.downcase == 'eur' ? '€' : '$'

    mail to: user.email
  end
end
