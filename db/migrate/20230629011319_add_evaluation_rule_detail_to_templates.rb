class AddEvaluationRuleDetailToTemplates < ActiveRecord::Migration[7.0]
  def change
    add_reference :templates, :evaluation_rule_detail, null: false, foreign_key: true
  end
end
