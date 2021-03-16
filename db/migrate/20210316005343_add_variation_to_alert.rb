class AddVariationToAlert < ActiveRecord::Migration[6.1]
  def change
    add_column :alerts, :variation, :float
  end
end
