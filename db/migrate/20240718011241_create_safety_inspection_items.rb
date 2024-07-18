class CreateSafetyInspectionItems < ActiveRecord::Migration[7.0]
  def change
    create_table :safety_inspection_items do |t|
      t.integer :state_compliance, default: 0
      t.string :observation

      t.timestamps
    end
    add_reference :safety_inspection_items, :safety_inspection, null: true, foreign_key: true
    add_reference :safety_inspection_items, :situation_condition, null: true, foreign_key: true
  end
end
