class CreateEpidemiologicalSurveillanceCases < ActiveRecord::Migration[7.0]
  def change
    create_table :epidemiological_surveillance_cases do |t|

      # SVE al que pertenece el caso
      t.references :epidemiological_surveillance_program,
                   null: false,
                   foreign_key: true,
                   index: { name: 'idx_sve_case_program' }

      # Empresa
      t.references :entity,
                   null: false,
                   foreign_key: true,
                   index: { name: 'idx_sve_case_entity' }

      # Trabajador
      t.references :user,
                   null: false,
                   foreign_key: true,
                   index: { name: 'idx_sve_case_user' }

      # ------------------------------------------------
      # FUENTE DE IDENTIFICACIÓN DEL CASO
      # 0 = Event
      # 1 = Encuesta
      # 2 = Otra fuente
      # ------------------------------------------------
      t.integer :source_type,
                null: false,
                default: 0

      # Event que originó el caso, cuando corresponda
      t.references :event,
                   foreign_key: true,
                   index: { name: 'idx_sve_case_event' }

      # Respuesta de encuesta que originó el caso,
      # cuando corresponda
      t.references :surveillance_survey_response,
                   foreign_key: true,
                   index: { name: 'idx_sve_case_response' }

      # Fecha de apertura del caso
      t.datetime :opened_at,
                  null: false

      # Fecha de cierre
      t.datetime :closed_at

      # ------------------------------------------------
      # ESTADO DEL CASO
      # 0 = Identificado
      # 1 = En evaluación
      # 2 = En seguimiento
      # 3 = Cerrado
      # 4 = No caso
      # ------------------------------------------------
      t.integer :status,
                null: false,
                default: 0

      # Responsable del seguimiento
      t.references :responsible,
                   foreign_key: { to_table: :users },
                   index: { name: 'idx_sve_case_responsible' }

      # Observaciones generales
      t.text :observations

      t.timestamps
    end
  end
end