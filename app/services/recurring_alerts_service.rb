class RecurringAlertsService
  class << self
    def send
      User.all.each do |user|
        next unless should_alert_user(user)
        warn("Sending alert for user: #{user.id}")

        recurring_alert = create_recurring_alert(user)
        NotificationsMailer.alert(recurring_alert, user).deliver
      end
    end

    private

    def should_alert_user(user)
      (user.last_recurring_alert.created_at + user.alerts_every.minutes) < DateTime.now
    end

    def create_recurring_alert(user)
      tickers = user.tickers.concat(user.coins.pluck(:symbol)).uniq
      coins_cmp = Cryptocompare::Price.find(user.tickers, user.default_currency)

      alert_lines = coins_cmp.map do |coin_cmp|
        create_alert_line(coin_cmp, user)
      end

      RecurringAlert.create(user: user, recurring_alert_lines: alert_lines)
    end

    def create_alert_line(coin_cmp, user)
      coin = Coin.find_or_create_by(symbol: coin_cmp[0], user_id: user.id)
      old_price = coin.last_price
      coin.update_attribute(:last_price, coin_cmp[1][user.default_currency])

      RecurringAlertLine.create(
        coin: coin,
        price: coin.last_price,
        variation: coin.variation(old_price)
      )
    end
  end
end
