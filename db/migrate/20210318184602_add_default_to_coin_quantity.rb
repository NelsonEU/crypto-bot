class AddDefaultToCoinQuantity < ActiveRecord::Migration[6.1]
  def change
    Coin.where(quantity: nil).update_all(quantity: 0)

    change_column_default(
      :coins,
      :quantity,
      from: nil,
      to: 0
    )
  end
end
