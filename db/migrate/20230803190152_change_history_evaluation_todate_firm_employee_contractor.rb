class ChangeHistoryEvaluationTodateFirmEmployeeContractor < ActiveRecord::Migration[7.0]
  def change
    change_column :history_evaluations, :date_firm_employee_contractor, :date
    change_column :history_evaluations, :date_firm_responsible_execution, :date
  end
end
