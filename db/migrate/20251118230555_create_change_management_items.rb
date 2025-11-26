class CreateChangeManagementItems < ActiveRecord::Migration[7.0]
  def change
    create_table :change_management_items do |t|
      t.string :activity_plannig
      t.integer :responsible_planning, default: 0
      t.string :communicate_change
      t.date :date_execution
      t.date :date_continue

      t.timestamps
    end
    add_reference :change_management_items, :change_management, null: true, foreign_key: true
  end
end
