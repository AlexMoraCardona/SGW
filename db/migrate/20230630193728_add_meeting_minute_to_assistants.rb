class AddMeetingMinuteToAssistants < ActiveRecord::Migration[7.0]
  def change
    add_reference :assistants, :meeting_minute, null: false, foreign_key: true
  end
end
