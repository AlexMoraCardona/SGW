class AddMeetingMinuteToMeetingAttendees < ActiveRecord::Migration[7.0]
  def change
    add_reference :meeting_attendees, :meeting_minute, null: false, foreign_key: true
  end
end
