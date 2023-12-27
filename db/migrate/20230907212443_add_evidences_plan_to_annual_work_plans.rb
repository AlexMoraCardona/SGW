class AddEvidencesPlanToAnnualWorkPlans < ActiveRecord::Migration[7.0]
  def change
    add_column :annual_work_plan_items, :evidences_plan, :string
  end
end
