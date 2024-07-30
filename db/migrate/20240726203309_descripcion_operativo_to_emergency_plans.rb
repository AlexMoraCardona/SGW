class DescripcionOperativoToEmergencyPlans < ActiveRecord::Migration[7.0]
  def change
    add_column :emergency_plans, :descripcion_operativo, :string
    add_column :emergency_plans, :rutas_evacuacion, :string
    add_column :emergency_plans, :punto_encuentro, :string
    add_column :emergency_plans, :codigo_empresa, :string
  end
end
