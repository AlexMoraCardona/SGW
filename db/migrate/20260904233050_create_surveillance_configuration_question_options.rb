class CreateSurveillanceConfigurationQuestionOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :surveillance_configuration_question_options do |t|
      t.references :surveillance_configuration_question,
                   null: false,
                   foreign_key: true,
                   index: {
                     name: "idx_surv_config_question_options_question"
                   }

      t.string :option, null: false

      t.integer :position,
                 null: false,
                 default: 0

      t.integer :status,
                 null: false,
                 default: 0

      t.timestamps
    end

    add_index :surveillance_configuration_question_options,
              [:surveillance_configuration_question_id, :position],
              name: "idx_surv_config_question_options_position"
  end
end
