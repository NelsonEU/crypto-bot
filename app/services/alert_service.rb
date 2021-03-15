class AlertService
  class << self
    def create_alerts
      coins = Coin.all
      coins.map do |coin|
        cmc_data = ::Coinmarketcap.price_info(coin.symbol)
        Alert.create(coin: coin, price: cmc_data['price'])
      end
    end
  end
end
