class RemoveDateFirmEmployeeContractorFromHistoryItems < ActiveRecord::Migration[7.0]
  def change
    remove_column :history_evaluations, :date_firm_employee_contractor, :string
    remove_column :history_evaluations, :date_firm_responsible_execution, :string
  end
end
