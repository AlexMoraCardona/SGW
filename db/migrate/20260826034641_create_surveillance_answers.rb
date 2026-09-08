
class CreateSurveillanceAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :surveillance_answers do |t|

      # Encuesta diligenciada a la que pertenece la respuesta
      t.references :surveillance_survey_response,
                   null: false,
                   foreign_key: true,
                   index: { name: 'idx_answer_response' }

      # Pregunta que se está respondiendo
      t.references :surveillance_question,
                   null: false,
                   foreign_key: true,
                   index: { name: 'idx_answer_question' }

      # Respuesta para preguntas de texto
      t.text :answer_text

      # Respuesta para preguntas verdadero / falso
      t.boolean :answer_boolean

      # Respuesta numérica, si posteriormente la necesitamos
      t.decimal :answer_number

      t.timestamps
    end

    # Una pregunta solo puede tener una respuesta dentro
    # de una misma encuesta diligenciada.
    add_index :surveillance_answers,
              [:surveillance_survey_response_id, :surveillance_question_id],
              unique: true,
              name: 'idx_answer_response_question'
  end
end