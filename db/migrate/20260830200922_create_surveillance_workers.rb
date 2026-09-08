class CreateSurveillanceWorkers < ActiveRecord::Migration[7.0]
  def change
    create_table :surveillance_workers do |t|

      t.references :epidemiological_surveillance_program,
                   null: false,
                   foreign_key: true,
                   index: {
                     name: "idx_survey_workers_program"
                   }

      t.references :user,
                   null: false,
                   foreign_key: true,
                   index: {
                     name: "idx_survey_workers_user"
                   }

      t.integer :status,
                null: false,
                default: 0

      t.date :entry_date,
             null: false

      t.date :exit_date

      t.text :observations

      t.timestamps
    end

    add_index :surveillance_workers,
              [:epidemiological_surveillance_program_id, :user_id],
              unique: true,
              name: "idx_survey_workers_program_user"
  end
end