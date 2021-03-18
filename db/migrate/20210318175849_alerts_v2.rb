class AlertsV2 < ActiveRecord::Migration[6.1]
  def change
    rename_table :alerts, :recurring_alert_lines

    create_table :recurring_alerts do |t|
      t.timestamps
    end

    add_reference :recurring_alert_lines, :recurring_alert, foreign_key: true, index: true
    add_reference :recurring_alerts, :user, foreign_key: true, index: true
  end
end
