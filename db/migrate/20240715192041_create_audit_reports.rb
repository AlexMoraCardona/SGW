class CreateAuditReports < ActiveRecord::Migration[7.0]
  def change
    create_table :audit_reports do |t|
      t.integer :user_representante, default: 0
      t.integer :user_audit, default: 0
      t.date :date_firm_representante
      t.date :date_firm_audit
      t.integer :firm_representante, default: 0
      t.integer :firm_audit, default: 0
      t.date :date_audit
      t.string :conclusions
      t.string :observations

      t.timestamps
    end
    add_reference :audit_reports, :entity, null: true, foreign_key: true
  end
end
