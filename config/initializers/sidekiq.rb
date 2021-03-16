Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('redis_url'), size: 1, network_timeout: 5 }
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('redis_url'), size: 12, network_timeout: 5 }
end

Sidekiq::Extensions.enable_delay!
