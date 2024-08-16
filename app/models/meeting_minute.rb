class MeetingMinute < ApplicationRecord
    has_many :meeting_attendees
    has_many :meeting_commitments
    has_many :assistants
    belongs_to :entity
    belongs_to :user
    belongs_to :evaluation
    has_rich_text :order_day
    has_rich_text :Issues
    has_rich_text :miscellaneous_propositions

    def self.ransackable_attributes(auth_object = nil)
        ["date", "entity_id", "evaluation_id"]
    end 

 

end
