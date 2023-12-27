class ChangeColumnHourToActivities < ActiveRecord::Migration[7.0]
  def change
    remove_column :activities, :hour, :date
    add_column :activities, :citation, :time
  end
end
