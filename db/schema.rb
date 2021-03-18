# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_18_184602) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coins", force: :cascade do |t|
    t.string "symbol"
    t.string "url"
    t.float "last_price"
    t.string "img_url"
    t.float "quantity", default: 0.0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_coins_on_user_id"
  end

  create_table "recurring_alert_lines", force: :cascade do |t|
    t.bigint "coin_id", null: false
    t.float "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "variation"
    t.bigint "recurring_alert_id"
    t.index ["coin_id"], name: "index_recurring_alert_lines_on_coin_id"
    t.index ["recurring_alert_id"], name: "index_recurring_alert_lines_on_recurring_alert_id"
  end

  create_table "recurring_alerts", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_recurring_alerts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "tickers", default: [], array: true
    t.string "email"
    t.string "password"
    t.string "username"
    t.string "at_twitter"
    t.string "default_currency"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "alerts_every", default: 1440
  end

  add_foreign_key "coins", "users"
  add_foreign_key "recurring_alert_lines", "coins"
  add_foreign_key "recurring_alert_lines", "recurring_alerts"
  add_foreign_key "recurring_alerts", "users"
end
