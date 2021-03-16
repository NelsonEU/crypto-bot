class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.text :tickers, array: true, default: []
      t.string :email
      t.string :password
      t.string :username
      t.string :at_twitter
      t.string :default_currency

      t.timestamps
    end
  end
end
