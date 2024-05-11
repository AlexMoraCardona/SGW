class ClasificationDangerToWorkingConditionItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :working_condition_items, :clasification_danger, null: true, foreign_key: true
    add_reference :working_condition_items, :clasification_danger_detail, null: true, foreign_key: true
  end
end
