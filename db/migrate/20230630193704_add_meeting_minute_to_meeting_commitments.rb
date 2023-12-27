class AddMeetingMinuteToMeetingCommitments < ActiveRecord::Migration[7.0]
  def change
    add_reference :meeting_commitments, :meeting_minute, null: false, foreign_key: true
  end
end
