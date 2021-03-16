class AlertService
  class << self
    def send_alerts
      User.all.each do |user|
        coins = Cryptocompare::Price.find(user.tickers, user.default_currency)

        alerts = coins.map do |coin_cmp|
          create_alerts(coin_cmp, user)
        end

        NotificationsMailer.alert(alerts, user).deliver
      end
    end

    private

    def create_alerts(coin_cmp, user)
      coin = Coin.find_or_create_by(symbol: coin_cmp[0], user_id: user.id)
      old_price = coin.last_price
      coin.update_attribute(:last_price, coin_cmp[1][user.default_currency])

      Alert.create(
        coin: coin,
        price: coin.last_price,
        variation: variation(coin.last_price, old_price)
      )
    end

    def variation(new_price, old_price)
      return 0 if old_price.nil? || old_price.zero?

      100 * (new_price - old_price) / old_price
    end
  end
end
