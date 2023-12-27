class AddItemNroToEvaluationRuleDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :evaluation_rule_details, :item_nro, :string
    add_column :evaluation_rule_details, :order_nro, :integer, default: 0
  end
end
