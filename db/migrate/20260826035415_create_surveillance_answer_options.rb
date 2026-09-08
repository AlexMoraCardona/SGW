
class CreateSurveillanceAnswerOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :surveillance_answer_options do |t|

      # Respuesta de la encuesta
      t.references :surveillance_answer,
                   null: false,
                   foreign_key: true,
                   index: { name: 'idx_answer_option_answer' }

      # Opción seleccionada
      t.references :surveillance_question_option,
                   null: false,
                   foreign_key: true,
                   index: { name: 'idx_answer_option_option' }

      t.timestamps
    end

    # Evita seleccionar dos veces la misma opción
    # para una misma respuesta.
    add_index :surveillance_answer_options,
              [:surveillance_answer_id, :surveillance_question_option_id],
              unique: true,
              name: 'idx_answer_option_unique'
  end
end