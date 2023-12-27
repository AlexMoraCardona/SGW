class AddEntityToMeetingMinutes < ActiveRecord::Migration[7.0]
  def change
    add_reference :meeting_minutes, :entity, null: false, foreign_key: true
    add_reference :meeting_minutes, :evaluation, null: false, foreign_key: true
    add_reference :meeting_minutes, :user, null: false, foreign_key: true
  end
end
