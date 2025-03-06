class MeetingCommitment < ApplicationRecord
    belongs_to :meeting_minute
    belongs_to :user
end
