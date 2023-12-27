class RemovevaluationRuleDetail < ActiveRecord::Migration[7.0]
  def change
    remove_column :templates, :evaluation_rule_detail_id, :integer
  end
end
