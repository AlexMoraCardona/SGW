class CreateEvaluations < ActiveRecord::Migration[7.0]
  def change
    create_table :evaluations do |t|
      t.integer :entity, default: 0
      t.date :date_evaluation
      t.integer :number_employees, default: 0
      t.integer :risk_level, default: 0

      t.timestamps
    end
  end
end
