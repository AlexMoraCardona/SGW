class CreateSurveillanceConfigurationQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :surveillance_configuration_questions do |t|
      t.references :surveillance_configuration,
                   null: false,
                   foreign_key: true,
                   index: {
                     name: "idx_surv_config_questions_config"
                   }

      t.text :question, null: false

      t.integer :question_type,
                 null: false,
                 default: 0

      t.integer :position,
                 null: false,
                 default: 0

      t.boolean :required,
                 null: false,
                 default: false

      t.text :help_text

      t.integer :status,
                 null: false,
                 default: 0

      t.timestamps
    end

    add_index :surveillance_configuration_questions,
              [:surveillance_configuration_id, :position],
              name: "idx_surv_config_questions_position"
  end
end

