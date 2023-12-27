class RemoveFailsFromEvaluationRuleDetails < ActiveRecord::Migration[7.0]
  def change
    remove_column :evaluation_rule_details, :fails, :string
  end
end
