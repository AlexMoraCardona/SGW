class CreateEpidemiologicalSurveillanceCaseFollowUps < ActiveRecord::Migration[7.0]
  def change
    create_table :epidemiological_surveillance_case_follow_ups do |t|

      # Caso SVE al que pertenece el seguimiento
      t.references :epidemiological_surveillance_case,
                   null: false,
                   foreign_key: true,
                   index: { name: 'idx_sve_followup_case' }

      # Usuario que realiza el seguimiento
      t.references :user,
                   null: false,
                   foreign_key: true,
                   index: { name: 'idx_sve_followup_user' }

      # Fecha y hora del seguimiento
      t.datetime :follow_up_date,
                 null: false

      # Tipo de actuación
      # 0 = Identificación
      # 1 = Evaluación inicial
      # 2 = Seguimiento
      # 3 = Visita
      # 4 = Contacto telefónico
      # 5 = Revisión documental
      # 6 = Cierre
      t.integer :follow_up_type,
                null: false,
                default: 2

      # Estado del caso después de la actuación
      # 0 = Identificado
      # 1 = En evaluación
      # 2 = En seguimiento
      # 3 = Cerrado
      # 4 = No caso
      t.integer :status,
                null: false,
                default: 2

      # Resultado de la actuación
      t.text :result

      # Observaciones
      t.text :observations

      # Fecha prevista para el siguiente seguimiento
      t.datetime :next_follow_up_date

      t.timestamps
    end

    # Evita dos seguimientos exactamente iguales
    # para el mismo caso en la misma fecha/hora.
    add_index :epidemiological_surveillance_case_follow_ups,
              [:epidemiological_surveillance_case_id, :follow_up_date],
              unique: true,
              name: 'idx_sve_followup_case_date'
  end
end