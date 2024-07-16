class CreateAuditReportItems < ActiveRecord::Migration[7.0]
  def change
    create_table :audit_report_items do |t|
      t.string :process
      t.string :finding
      t.integer :type_finding, default: 0

      t.timestamps
    end
    add_reference :audit_report_items, :audit_report, null: true, foreign_key: true
  end
end
