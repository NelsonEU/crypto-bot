class AddUserToCoins < ActiveRecord::Migration[6.1]
  def change
    add_reference :coins, :user, null: true, foreign_key: true
  end
end
