class CreateLegalRules < ActiveRecord::Migration[7.0]
  def change
    create_table :legal_rules do |t|
      t.string :risk_factor
      t.string :requirement
      t.string :rule_name
      t.string :fecha_norma
      t.string :issuing_entity
      t.string :applicable_article
      t.string :description_compliance
      t.integer :state_norma, default: 0
      t.integer :clasification_norma, default: 0

      t.timestamps
    end
  end
end
