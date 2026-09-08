class CreateSurveillanceReports < ActiveRecord::Migration[7.0]
  def change
    create_table :surveillance_reports do |t|
      t.references :epidemiological_surveillance_program,
                   null: false,
                   foreign_key: true,
                   index: {
                     name: "idx_sve_reports_program"
                   }

      # Información general automática
      t.string :responsible_name
      t.string :responsible_position
      t.string :responsible_license

      # Información manual
      t.integer :number_of_workers

      # Firma
      t.boolean :autoriza_firma, null: false, default: false
      t.date :fecha_firma

      # Trazabilidad del informe
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :surveillance_reports,
              :epidemiological_surveillance_program_id,
              unique: true,
              name: "idx_sve_reports_program_unique"
  end
end