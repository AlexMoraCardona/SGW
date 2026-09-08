class CreateCharacterizations < ActiveRecord::Migration[7.0]
  def change
    create_table :characterizations do |t|

      t.references :surveillance_worker,
                   null: false,
                   foreign_key: true,
                   index: {
                     unique: true,
                     name: "idx_characterizations_worker_unique"
                   }

      t.integer :pve_group,
                 null: false,
                 default: 0

      t.integer :principal_exposure,
                 null: false,
                 default: 0

      t.integer :frequency,
                 null: false,
                 default: 0

      t.boolean :respirator_required,
                  null: false,
                  default: false

      t.integer :characterization_status,
                 null: false,
                 default: 0

      t.timestamps
    end
  end
end
