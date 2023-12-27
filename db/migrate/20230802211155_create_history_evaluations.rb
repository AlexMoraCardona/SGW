class CreateHistoryEvaluations < ActiveRecord::Migration[7.0]
  def change
    create_table :history_evaluations do |t|
      t.date :date_create_evaluation
      t.date :date_history_evaluation
      t.integer :number_employees, default: 0
      t.integer :score, default: 0
      t.decimal :percentage, default: 0
      t.decimal :result, default: 0
      t.string :observation
      t.integer :id_employee_contractor, default: 0
      t.string :firm_employee_contractor
      t.string :date_firm_employee_contractor
      t.integer :id_responsible_execution, default: 0
      t.string :firm_responsible_execution
      t.string :date_firm_responsible_execution
      t.integer :completed_items, default: 0
      t.integer :unfulfilled_items, default: 0
      t.integer :not_apply_items, default: 0
      
      t.timestamps
    end
  end
end
