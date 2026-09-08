
class CreateSurveillanceSurveyResponses < ActiveRecord::Migration[7.0]
  def change
    create_table :surveillance_survey_responses do |t|

      # Encuesta que fue diligenciada
      t.references :surveillance_survey,
                   null: false,
                   foreign_key: true,
                   index: { name: 'idx_response_survey' }

      # Trabajador que diligencia la encuesta
      t.references :user,
                   null: false,
                   foreign_key: true,
                   index: { name: 'idx_response_user' }

      # Empresa a la que pertenece la respuesta
      t.references :entity,
                   null: false,
                   foreign_key: true,
                   index: { name: 'idx_response_entity' }

      # Fecha en que se diligenció la encuesta
      t.datetime :response_date,
                  null: false

      # Estado de revisión por parte del asesor
      # 0 = pendiente
      # 1 = revisada
      t.integer :review_status,
                null: false,
                default: 0

      # Usuario que realizó la revisión
      t.references :reviewed_by,
                   foreign_key: { to_table: :users },
                   index: { name: 'idx_response_reviewer' }

      # Fecha de revisión
      t.datetime :reviewed_at

      # Determina si el asesor seleccionó la encuesta
      # para continuar el proceso dentro del SVE
      t.boolean :selected_for_sve,
                null: false,
                default: false

      # Fecha en que fue seleccionada para SVE
      t.datetime :selected_at

      # Estado de la respuesta dentro del proceso de revisión
      # 0 = pendiente
      # 1 = en evaluación
      # 2 = en seguimiento
      # 3 = cerrado
      # 4 = no candidato
      t.integer :status,
                null: false,
                default: 0

      # Observaciones generales del asesor
      t.text :observations

      t.timestamps
    end

    # Evita registrar exactamente la misma encuesta,
    # para el mismo trabajador y empresa, dos veces
    # con la misma fecha/hora.
    add_index :surveillance_survey_responses,
              [:surveillance_survey_id, :user_id, :response_date],
              unique: true,
              name: 'idx_response_survey_user_date'
  end
end