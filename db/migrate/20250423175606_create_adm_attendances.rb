class CreateAdmAttendances < ActiveRecord::Migration[7.0]
  def change
    create_table :adm_attendances do |t|
      t.date :date_attendance
      t.string :description
      t.time :time_initial
      t.time :time_final

      t.timestamps
    end
    add_reference :adm_attendances, :entity, null: true, foreign_key: true
    add_reference :adm_attendances, :user, null: true, foreign_key: true

  end
end
