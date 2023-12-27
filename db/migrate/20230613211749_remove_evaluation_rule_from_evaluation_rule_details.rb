class RemoveEvaluationRuleFromEvaluationRuleDetails < ActiveRecord::Migration[7.0]
  def change
    remove_column :evaluation_rule_details, :evaluation_rule, :string
    remove_column :evaluation_rule_details, :standar_detail_item, :string
  end
end
