class UserToMeetingAttendee < ActiveRecord::Migration[7.0]
  def change
    add_reference :meeting_attendees, :user, null: true, foreign_key: true
    add_reference :meeting_commitments, :user, null: true, foreign_key: true
    add_reference :assistants, :user, null: true, foreign_key: true
  end
end
