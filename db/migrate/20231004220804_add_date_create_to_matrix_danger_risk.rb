class AddDateCreateToMatrixDangerRisk < ActiveRecord::Migration[7.0]
  def change
    add_column :matrix_danger_risks, :date_create, :date
    add_column :matrix_danger_risks, :date_update, :date
    add_column :matrix_corrective_actions, :date_create, :date
    add_column :matrix_corrective_actions, :date_update, :date
    add_column :annual_work_plans, :date_create, :date
    add_column :annual_work_plans, :date_update, :date
  end
end
