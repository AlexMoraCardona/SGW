class AddObservationToEvaluationRuleDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :evaluation_rule_details, :observation, :string
    add_column :evaluation_rule_details, :meets, :integer, default: 0
    add_column :evaluation_rule_details, :fails, :integer, default: 0
    add_column :evaluation_rule_details, :apply, :integer, default: 0
    add_reference :evaluation_rule_details, :evaluation, null: true, foreign_key: true
  end
end
