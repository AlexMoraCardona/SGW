class CreateReportOfficials < ActiveRecord::Migration[7.0]
  def change
    create_table :report_officials do |t|
      t.date :date
      t.integer :number_oficial
      t.integer :user_reports
      t.integer :working_days_month
      t.references :entity

      t.timestamps
    end
  end
end
