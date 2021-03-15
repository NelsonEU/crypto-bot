class CreateAlerts < ActiveRecord::Migration[6.1]
  def change
    create_table :alerts do |t|
      t.references :coin, null: false, foreign_key: true
      t.float :price

      t.timestamps
    end
  end
end
