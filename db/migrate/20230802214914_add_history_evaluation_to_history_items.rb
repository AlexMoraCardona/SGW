class AddHistoryEvaluationToHistoryItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :history_items, :history_evaluation, null: false, foreign_key: true
  end
end
