
class CreateSurveillanceQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :surveillance_questions do |t|

      # Encuesta a la que pertenece la pregunta
      t.references :surveillance_survey,
                   null: false,
                   foreign_key: true,
                   index: { name: 'idx_question_survey' }

      # Texto de la pregunta
      t.text :question, null: false

      # Tipo de respuesta
      # 0 = campo abierto
      # 1 = verdadero / falso
      # 2 = selección única
      # 3 = selección múltiple
      t.integer :question_type,
                null: false,
                default: 0

      # Orden en que aparece la pregunta
      t.integer :position,
                null: false,
                default: 0

      # Indica si el asesor debe responder obligatoriamente
      t.boolean :required,
                  null: false,
                  default: false

      # Permite desactivar una pregunta sin eliminarla
      t.boolean :active,
                  null: false,
                  default: true

      t.timestamps
    end

    # Evita posiciones duplicadas dentro de la misma encuesta
    add_index :surveillance_questions,
              [:surveillance_survey_id, :position],
              unique: true,
              name: 'idx_question_survey_position'
  end
end