class FecNormaToLegalRules < ActiveRecord::Migration[7.0]
  def change
    add_column :legal_rules, :fec_norma, :date
    add_column :legal_rules, :year, :integer, default: 0
    add_column :matrix_legal_items, :fec_norma, :date
  end
end
