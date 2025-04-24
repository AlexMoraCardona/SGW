class CreateAttendances < ActiveRecord::Migration[7.0]
  def change
    create_table :attendances do |t|
      t.date :date_attendance
      t.integer :confirm_attendance, default: 0

      t.timestamps
    end
    add_reference :attendances, :adm_attendance, null: true, foreign_key: true
  end
end
