class ActionImprovementToImprovementItems < ActiveRecord::Migration[7.0]
  def change
    change_column :improvement_items, :action_improvement, :string
  end
end
