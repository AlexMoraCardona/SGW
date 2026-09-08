class CreateSurveillanceReportProcesses < ActiveRecord::Migration[7.0]
  def change
    create_table :surveillance_report_processes do |t|
      t.references :surveillance_report,
                   null: false,
                   foreign_key: true,
                   index: {
                     name: "idx_sve_report_processes_report"
                   }

      t.string :process_name
      t.text :risks

      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :surveillance_report_processes,
              [:surveillance_report_id, :position],
              name: "idx_sve_report_processes_position"
  end
end