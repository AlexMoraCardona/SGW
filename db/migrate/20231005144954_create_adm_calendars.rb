class CreateAdmCalendars < ActiveRecord::Migration[7.0]
  def change
    create_table :adm_calendars do |t|
      t.integer :year, default: 1900
      t.integer :bisiesto, default: 0
      t.integer :day_initial, default: 1
      t.integer :generated, default: 0

      t.timestamps
    end
  end
end
