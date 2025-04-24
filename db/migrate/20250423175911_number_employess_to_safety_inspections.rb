class NumberEmployessToSafetyInspections < ActiveRecord::Migration[7.0]
  def change
    add_column :matrix_legal_items, :fecha_norma, :string
    add_column :safety_inspections, :number_employees, :integer, default: 0
    add_column :users, :date_nacimiento, :date
    add_column :protection_elements, :entity, :integer, default: 0
    add_reference :matrix_legal_items, :legal_rule, null: true, foreign_key: true
  end
end
