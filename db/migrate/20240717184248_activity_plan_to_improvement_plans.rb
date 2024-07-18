class ActivityPlanToImprovementPlans < ActiveRecord::Migration[7.0]
  def change
    remove_column :improvement_plans, :activity_plan, :string
    remove_column :improvement_plans, :action_improvement, :integer
    remove_column :improvement_plans, :date_initial, :date
    remove_column :improvement_plans, :date_fin, :date
    remove_column :improvement_plans, :aim_improvement, :string

  end
end
