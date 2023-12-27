class AddEntityToHistoryEvaluations < ActiveRecord::Migration[7.0]
  def change
    add_reference :history_evaluations, :entity, null: false, foreign_key: true
    add_reference :history_evaluations, :evaluation, null: false, foreign_key: true
    add_reference :history_evaluations, :risk_level, null: false, foreign_key: true
    add_reference :history_evaluations, :rule, null: false, foreign_key: true

  end
end
