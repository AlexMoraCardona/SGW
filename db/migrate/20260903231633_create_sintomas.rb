class CreateSintomas < ActiveRecord::Migration[7.0]
  def change
    create_table :sintomas do |t|

      t.references :surveillance_worker,
                   null: false,
                   foreign_key: true,
                   index: {
                     unique: true,
                     name: "idx_sintomas_worker_unique"
                   }

      # Síntomas
      t.boolean :fiebre, default: false, null: false
      t.boolean :tos, default: false, null: false
      t.boolean :dolor_garganta, default: false, null: false
      t.boolean :congestion_nasal, default: false, null: false
      t.boolean :dificultad_respirar, default: false, null: false
      t.boolean :dolor_pecho, default: false, null: false
      t.boolean :dolor_cabeza, default: false, null: false
      t.boolean :dolores_musculares, default: false, null: false
      t.boolean :escalofrios, default: false, null: false
      t.boolean :fatiga_cansancio_inusual, default: false, null: false
      t.boolean :nauseas_vomito, default: false, null: false
      t.boolean :diarrea, default: false, null: false
      t.boolean :otro, default: false, null: false
      t.string :otro_cual

      t.boolean :ninguno_anteriores, default: false, null: false

      # Condiciones / exposición
      t.boolean :incapacidad, default: false, null: false
      t.boolean :contacto_respiratorio, default: false, null: false
      t.boolean :irritacion_asociada_trabajo, default: false, null: false

      # Acción SST
      t.integer :accion_sst, default: 0, null: false

      # Seguimiento
      t.integer :seguimiento, default: 0, null: false

      t.timestamps
    end
  end
end