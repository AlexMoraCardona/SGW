class AddStandarDetailItemToEvaluationRuleDetails < ActiveRecord::Migration[7.0]
  def change
    add_reference :evaluation_rule_details, :standar_detail_item, null: false, foreign_key: true
  end
end


