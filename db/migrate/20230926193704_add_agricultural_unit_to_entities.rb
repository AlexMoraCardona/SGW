class AddAgriculturalUnitToEntities < ActiveRecord::Migration[7.0]
  def change
    add_column :entities, :agricultural_unit, :integer, default: 0
  end
end
