class CreateSurveillanceActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :surveillance_activities do |t|
      t.references :epidemiological_surveillance_program,
                   null: false,
                   foreign_key: true,
                   index: { name: "idx_sve_activities_program" }

      t.references :responsible,
                   foreign_key: { to_table: :users }

      t.string :name, null: false
      t.text :description

      t.date :planned_date
      t.date :execution_date

      t.integer :status, null: false, default: 0

      t.text :observations

      t.timestamps
    end

    add_index :surveillance_activities,
              [:epidemiological_surveillance_program_id, :planned_date],
              name: "idx_sve_activities_program_date"
  end
end