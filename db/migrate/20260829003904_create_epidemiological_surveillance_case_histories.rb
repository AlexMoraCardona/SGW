class CreateEpidemiologicalSurveillanceCaseHistories < ActiveRecord::Migration[7.0]

  def change

    create_table :epidemiological_surveillance_case_histories do |t|

      t.references :epidemiological_surveillance_case,
                   null: false,
                   index: false,
                   foreign_key: {
                     name: "fk_sve_case_histories_case"
                   }

      t.references :user,
                   null: false,
                   index: false,
                   foreign_key: true

      t.integer :previous_status

      t.integer :new_status,
                   null: false

      t.datetime :changed_at,
                   null: false

      t.text :observations

      t.timestamps

    end

    add_index :epidemiological_surveillance_case_histories,
              :epidemiological_surveillance_case_id,
              name: "idx_sve_histories_case"

    add_index :epidemiological_surveillance_case_histories,
              :user_id,
              name: "idx_sve_histories_user"

    add_index :epidemiological_surveillance_case_histories,
              [
                :epidemiological_surveillance_case_id,
                :changed_at
              ],
              name: "idx_sve_histories_case_date"

  end

end