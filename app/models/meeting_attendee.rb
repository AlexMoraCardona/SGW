class MeetingAttendee < ApplicationRecord
    belongs_to :meeting_minute
    belongs_to :user
end
