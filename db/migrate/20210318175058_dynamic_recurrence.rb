class DynamicRecurrence < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :alerts_every, :integer, default: 1440
  end
end
