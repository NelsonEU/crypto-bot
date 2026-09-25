# Crypto Bot

Crypto Bot is a small Rails app that emails you your crypto portfolio on a schedule.

For each user, it fetches current prices from [CryptoCompare](https://www.cryptocompare.com/). It then works out how much each coin's price has changed since the last email and sends an HTML summary like this:

| Coin | Price | Quantity | Value | Variation |
|------|-------|----------|-------|-----------|
| BTC  | 48 312.5 € | 0.25 | 12 078.13 € | +3.21% (green) |
| ETH  | 1 512.2 €  | 2.0  | 3 024.40 €  | -1.05% (red) |

The email also shows the total portfolio value. Rows are sorted from the biggest gain to the biggest loss.

There is no web UI or API: the routes are empty. You manage users and holdings from the Rails console, and a rake task sends the emails.

## How it works

```
 scheduler (cron / Heroku Scheduler)
            │  every N minutes
            ▼
 rake recurring_alerts ──► RecurringAlertsService.send
                                   │
                    for each User whose last alert is older
                    than `alerts_every` minutes:
                                   │
             ┌─────────────────────┼──────────────────────────┐
             ▼                     ▼                          ▼
   CryptoCompare price     update Coin.last_price,    NotificationsMailer.alert
   for user.tickers in     store a RecurringAlert     (HTML email with prices,
   user.default_currency   + one line per coin        values and variations)
                           (price, variation %)
```

- **[lib/tasks/scheduler.rake](lib/tasks/scheduler.rake)**: the `recurring_alerts` task, which is the only entry point.
- **[app/services/recurring_alerts_service.rb](app/services/recurring_alerts_service.rb)**: decides who needs an email, fetches prices, saves a snapshot and sends the mail.
- **[app/mailers/notifications_mailer.rb](app/mailers/notifications_mailer.rb)** and **[its template](app/views/notifications_mailer/alert.html.erb)**: build the email.

The task decides for itself who is due. You can run it often, for example every 10 minutes, and each user still gets emails only at their own rhythm.

### Data model

| Model | Purpose | Notable columns |
|-------|---------|-----------------|
| `User` | Email recipient and settings | `email`, `username` (used in the greeting, falls back to email), `tickers` (string array of symbols to track, e.g. `{BTC,ETH}`), `default_currency` (`EUR` or `USD`), `alerts_every` (minutes between emails, default `1440` = daily) |
| `Coin` | A symbol tracked by one user | `symbol`, `quantity` (how much you hold, default `0`), `last_price` (price from the last run), `user_id` |
| `RecurringAlert` | One sent notification (a snapshot) | `user_id`, `created_at` |
| `RecurringAlertLine` | One coin's row in a snapshot | `coin_id`, `price`, `variation` (% change since the previous run) |

Variation is computed as `100 × (new_price − previous last_price) / previous last_price`. It shows the change since the user's previous email, not over a fixed 24 hours.

## Tech stack

- Ruby 2.7.2, Rails 6.1 (API-mode controllers)
- PostgreSQL
- Redis and Sidekiq. Both are configured and started by the Procfiles, but the alert task runs synchronously. Redis is still **required at boot** (see `REDIS_URL` below).
- [`cryptocompare`](https://github.com/alexanderdavidpan/cryptocompare) gem for prices
- Action Mailer: `letter_opener` in development, SMTP (OVH, `ssl0.ovh.net:587`) in production

## Setup

### Prerequisites

- Ruby 2.7.2 (see `.ruby-version`)
- PostgreSQL, with a `crypto_bot` role that can create databases
- Redis

### Install

```bash
bundle install
yarn install

createuser -s crypto_bot        # if the role doesn't exist yet
bin/rails db:create db:migrate
```

### Configuration

At boot, the app loads environment variables from `config/application.yml` (git-ignored). Create that file:

```yaml
# config/application.yml
REDIS_URL: redis://localhost:6379/0
ALERT_EMAIL_ADRESS: bot@example.com      # "from" address and SMTP username
ALERT_EMAIL_PASSWORD: change-me          # SMTP password (production only)
ALERT_EMAIL_DOMAIN: example.com          # SMTP HELO domain (production only)
```

| Variable | Required in | Used for |
|----------|-------------|----------|
| `REDIS_URL` | all envs (read at boot) | Sidekiq / Redis connection |
| `ALERT_EMAIL_ADRESS` | all envs | Sender address; SMTP login in production. Note the spelling (`ADRESS`). |
| `ALERT_EMAIL_PASSWORD` | production | SMTP password |
| `ALERT_EMAIL_DOMAIN` | production | SMTP domain |
| `DATABASE_URL` | production | See [Deployment](#deployment) |

### Create a user

Use the Rails console (`bin/rails console`):

```ruby
user = User.create!(
  email: "you@example.com",
  username: "you",
  tickers: ["BTC", "ETH", "ADA"],
  default_currency: "EUR",
  alerts_every: 1440              # minutes; 1440 = once a day
)

# Holdings (optional: coins with quantity 0 still show price and variation)
Coin.create!(user: user, symbol: "BTC", quantity: 0.25)
Coin.create!(user: user, symbol: "ETH", quantity: 2)

# REQUIRED: bootstrap the schedule. The service reads the user's last alert
# and crashes if there is none.
RecurringAlert.create!(user: user, created_at: 2.days.ago)
```

You don't have to create a `Coin` for every ticker, because the task creates missing ones on its first run. A coin only gets a price if its symbol is in `user.tickers`, though.

## Running

### Development

```bash
# starts redis, sidekiq and the rails server (Procfile.dev)
foreman start -f Procfile.dev

# send any due alerts; in development emails open in your browser (letter_opener)
bin/rails recurring_alerts
```

To force an email right away, make the user's latest alert old enough:

```ruby
User.find_by(email: "you@example.com").last_recurring_alert.update!(created_at: 2.days.ago)
```

### Tests

```bash
bin/rails test
```

The test files are only generator stubs at the moment. There is no real test coverage.

## Deployment

The `Procfile` is set up for Heroku:

- `web`: Puma
- `worker`: Sidekiq
- `release`: runs `rake db:migrate`

To send emails, schedule `rake recurring_alerts` with **Heroku Scheduler** (or cron on another host). Run it at least as often as the smallest `alerts_every` value among your users.

Add-ons and config needed: Heroku Postgres, which sets `DATABASE_URL` and overrides the `production` block in `config/database.yml`; a Redis add-on that sets `REDIS_URL`; the `ALERT_EMAIL_*` variables; and `RAILS_MASTER_KEY`.
