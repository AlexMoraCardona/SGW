
class CreateSurveillanceSurveys < ActiveRecord::Migration[7.0]
  def change
    create_table :surveillance_surveys do |t|

      # SVE al que pertenece la encuesta
      t.references :epidemiological_surveillance_program,
                   null: false,
                   foreign_key: true,
                   index: { name: 'idx_survey_program' }

      # Información de la encuesta
      t.string :name, null: false
      t.text :description

      # Versión de la encuesta
      t.string :version, null: false, default: '1.0'

      # Permite activar/desactivar la encuesta
      t.boolean :active, null: false, default: true

      # Usuario que creó la encuesta
      t.references :created_by,
                   foreign_key: { to_table: :users }

      t.timestamps
    end

    # Evita que existan dos encuestas con el mismo nombre
    # dentro del mismo SVE y con la misma versión.
    add_index :surveillance_surveys,
              [:epidemiological_surveillance_program_id, :name, :version],
              unique: true,
              name: 'idx_survey_program_name_version'
  end
end