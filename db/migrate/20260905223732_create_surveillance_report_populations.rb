class CreateSurveillanceReportPopulations < ActiveRecord::Migration[7.0]
  def change
    create_table :surveillance_report_populations do |t|
      t.references :surveillance_report,
                   null: false,
                   foreign_key: true,
                   index: {
                     name: "idx_sve_report_populations_report"
                   }

      t.string :priority
      t.string :exposure
      t.integer :number_exposed

      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :surveillance_report_populations,
              [:surveillance_report_id, :position],
              name: "idx_sve_report_populations_position"
  end
end
