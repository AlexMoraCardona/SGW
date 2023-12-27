class AddEntityToEvaluations < ActiveRecord::Migration[7.0]
  def change
    add_reference :evaluations, :entity, null: true, foreign_key: true
    add_reference :evaluations, :risk_level, null: true, foreign_key: true
    add_reference :evaluations, :rule, null: true, foreign_key: true
  end
end
