class ChangeHistoryEvaluation < ActiveRecord::Migration[7.0]
  def change
    change_column :history_evaluations, :result, :string
  end
end
