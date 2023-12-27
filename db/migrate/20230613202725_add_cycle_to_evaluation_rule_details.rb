class AddCycleToEvaluationRuleDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :evaluation_rule_details, :cycle, :integer, default: 0
    add_column :evaluation_rule_details, :maximun_value, :decimal, default: 0
  end
end
