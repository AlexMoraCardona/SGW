class CreateSurveillanceInspections < ActiveRecord::Migration[7.0]
  def change
    create_table :surveillance_inspections do |t|
      t.references :epidemiological_surveillance_program,
                   null: false,
                   foreign_key: true,
                   index: {
                     name: "idx_surv_inspections_program"
                   }

      t.date :fecha, null: false

      t.references :company_area,
                   null: false,
                   foreign_key: true

      t.string :inspector, null: false
      t.string :fuente_emision, null: false

      t.integer :control_fuente, null: false, default: 2
      t.integer :extraccion_operativa, null: false, default: 2
      t.integer :sin_obstrucciones, null: false, default: 2
      t.integer :mantenimiento_vigente, null: false, default: 2
      t.integer :fugas_derrames_controlados, null: false, default: 2
      t.integer :almacenamiento_adecuado, null: false, default: 2
      t.integer :epp_disponible, null: false, default: 2
      t.integer :uso_adecuado, null: false, default: 2
      t.integer :ventilacion_areas_comunes, null: false, default: 2

      t.text :hallazgo_critico
      t.text :accion

      t.string :responsable
      t.date :fecha_limite

      t.integer :estado, null: false, default: 0

      t.timestamps
    end

    add_index :surveillance_inspections,
              [:epidemiological_surveillance_program_id, :fecha],
              name: "idx_surv_inspections_program_fecha"
  end
end