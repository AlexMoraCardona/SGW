class AddEvaluationToHistoryItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :history_items, :evaluation, null: false, foreign_key: true
    add_reference :history_items, :evaluation_rule_detail,  null: false, foreign_key: true
  end
end
