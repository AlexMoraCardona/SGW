class AddEarringToAnnualWorkPlanItems < ActiveRecord::Migration[7.0]
  def change
    add_column :annual_work_plan_items, :earring, :integer, default: 0
  end
end
