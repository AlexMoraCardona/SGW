class CreateMeetingMinutes < ActiveRecord::Migration[7.0]
  def change
    create_table :meeting_minutes do |t|
      t.date :date
      t.time :start_time
      t.time :end_time
      t.string :code
      t.integer :version
      t.integer :record_number
      t.string :area_process_committee
      t.string :objective_meeting
      t.string :meeting_type
      t.string :place
      t.string :order_day
      t.string :Issues
      t.string :miscellaneous_propositions
      t.string :elaborated

      t.timestamps
    end
  end
end
