class ScoreIntToHistoryEvaluations < ActiveRecord::Migration[7.0]
  def change
    add_column :history_evaluations, :score_int, :decimal, default: 0
    add_column :history_evaluations, :percentage_int, :decimal, default: 0
  end
end
