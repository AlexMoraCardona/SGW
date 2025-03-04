class ScoreIntToEvaluations < ActiveRecord::Migration[7.0]
  def change
    add_column :evaluations, :score_int, :decimal, default: 0
    add_column :evaluations, :percentage_int, :decimal, default: 0
  end
end
