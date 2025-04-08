class RecommendationToSafetyInspectionItems < ActiveRecord::Migration[7.0]
  def change
    add_column :safety_inspection_items, :recommendations, :string
    add_column :safety_inspection_items, :proposed_intervention, :string
    add_column :protection_elements, :cost_element, :integer, default: 0
    add_column :protection_elements, :cant_person_use, :integer, default: 0
    add_column :protection_elements, :prom_person_use, :string
    add_column :protection_elements, :total_anual_person, :integer, default: 0
    add_column :protection_elements, :stok_min, :integer, default: 0
    add_column :protection_elements, :proveedor_element, :string
    add_column :protection_elements, :technical_sheet, :string
  end
end
