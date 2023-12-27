class RemoveItemsFromMatrixLegals < ActiveRecord::Migration[7.0]
  def change
    remove_column :matrix_legals, :consecutive, :integer
    remove_column :matrix_legals, :risk_factor, :string
    remove_column :matrix_legals, :issuing_entity, :string
    remove_column :matrix_legals, :requirement, :string
    remove_column :matrix_legals, :rule_name, :string
    remove_column :matrix_legals, :applicable_article, :string
    remove_column :matrix_legals, :apply, :integer
    remove_column :matrix_legals, :evidence_compliance, :string
    remove_column :matrix_legals, :responsible, :string
    remove_column :matrix_legals, :meets, :integer
    remove_column :matrix_legals, :description_compliance, :string
  end
end


