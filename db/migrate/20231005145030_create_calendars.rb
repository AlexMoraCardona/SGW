class CreateCalendars < ActiveRecord::Migration[7.0]
  def change
    create_table :calendars do |t|
      t.integer :day, default: 1
      t.integer :month, default: 1
      t.integer :year, default: 1900
      t.integer :festive, default: 0
      t.string :name_day

      t.timestamps
    end
   
  end
end
