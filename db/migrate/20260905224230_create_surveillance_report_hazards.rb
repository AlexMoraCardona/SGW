class CreateSurveillanceReportHazards < ActiveRecord::Migration[7.0]
  def change
    create_table :surveillance_report_hazards do |t|
      t.references :surveillance_report,
                   null: false,
                   foreign_key: true,
                   index: {
                     name: "idx_sve_report_hazards_report"
                   }

      t.string :agent
      t.string :substance_product
      t.text :possible_effects

      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :surveillance_report_hazards,
              [:surveillance_report_id, :position],
              name: "idx_sve_report_hazards_position"
  end
end
