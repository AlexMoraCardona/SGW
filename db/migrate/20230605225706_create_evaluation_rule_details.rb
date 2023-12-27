class CreateEvaluationRuleDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :evaluation_rule_details do |t|
      t.integer :evaluation_rule, default: 0
      t.integer :standar_detail_item, default: 0
      t.decimal :score, default: 0
      t.string :description

      t.timestamps
    end
  end
end
