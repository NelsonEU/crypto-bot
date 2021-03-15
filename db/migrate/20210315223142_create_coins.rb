class CreateCoins < ActiveRecord::Migration[6.1]
  def change
    create_table :coins do |t|
      t.string :symbol
      t.string :url
      t.float :last_price
      t.string :img_url
      t.float :quantity

      t.timestamps
    end
  end
end
