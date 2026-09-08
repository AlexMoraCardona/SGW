
class CreateSurveillanceQuestionOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :surveillance_question_options do |t|

      # Pregunta a la que pertenece la opción
      t.references :surveillance_question,
                   null: false,
                   foreign_key: true,
                   index: { name: 'idx_option_question' }

      # Texto que verá el trabajador
      t.string :option_text, null: false

      # Valor interno de la opción
      t.string :option_value

      # Orden de la opción
      t.integer :position,
                   null: false,
                   default: 0

      # Permite desactivar una opción sin eliminarla
      t.boolean :active,
                   null: false,
                   default: true

      t.timestamps
    end

    # Evita opciones repetidas dentro de la misma pregunta
    add_index :surveillance_question_options,
              [:surveillance_question_id, :option_text],
              unique: true,
              name: 'idx_option_question_text'
  end
end