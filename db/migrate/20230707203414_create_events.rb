class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.date :date_new
      t.integer :work_accident, default: 0
      t.date :disability_start_date
      t.date :disability_end_date
      t.integer :mortal_accident, default: 0
      t.integer :occupational_disease, default: 0
      t.integer :laboral_inhability, default: 0
      t.integer :common_inhability, default: 0
      t.integer :days_absenteeism, default: 0
      t.integer :user_reports
      t.references :user
      t.references :entity
      
      t.timestamps
    end
  end
end
