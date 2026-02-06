class CreateInternalReports < ActiveRecord::Migration[7.0]
  def change
    create_table :internal_reports do |t|
      t.date :date_report
      t.integer :type_report, default: 0
      t.time :time_report
      t.string :place
      t.string :description
      t.string :name_person
      t.integer :user, default: 0
      t.date :date_user
      t.integer :firm_user, default: 0
      t.integer :state_report, default: 0

      t.timestamps
    end
    add_reference :internal_reports, :entity, null: true, foreign_key: true
  end
end
