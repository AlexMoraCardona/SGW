class CreateMeetingAttendees < ActiveRecord::Migration[7.0]
  def change
    create_table :meeting_attendees do |t|
      t.string :name
      t.string :post
      t.string :process_area

      t.timestamps
    end
  end
end
