class AddHistoryEvaluation < ActiveRecord::Migration[7.0]
  def change
    add_column :history_evaluations, :date_firm_employee, :date
    add_column :history_evaluations, :date_firm_responsible, :date 
  end
end
