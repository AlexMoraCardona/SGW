class CreateImprovementItems < ActiveRecord::Migration[7.0]
  def change
    create_table :improvement_items do |t|
      t.string :activity_plan
      t.integer :action_improvement, default: 0
      t.date :date_initial
      t.date :date_fin
      t.string :aim_improvement
      t.string :resources_improvement
      t.string :responsible_action
      t.integer :percentage_compliance, default: 0
      t.string :observation

      t.timestamps
    end
    add_reference :improvement_items, :improvement_plan, null: true, foreign_key: true
  end
end
