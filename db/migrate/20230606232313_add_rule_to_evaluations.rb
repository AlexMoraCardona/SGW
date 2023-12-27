class AddRuleToEvaluations < ActiveRecord::Migration[7.0]
  def change
    add_column :evaluations, :rule, :integer, default: 0
    add_column :evaluations, :score, :decimal, default: 0
    add_column :evaluations, :percentage, :decimal, default: 0
    add_column :evaluations, :result, :string
    add_column :evaluations, :observation, :string
  end
end
