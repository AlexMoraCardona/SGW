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


    def self.copiar_acta(dato)
        acta = MeetingMinute.find(dato)
        acta_nueva  = MeetingMinute.new
        acta_nueva.date  = Time.now
        acta_nueva.start_time = acta.start_time
        acta_nueva.end_time = acta.end_time
        acta_nueva.code = acta.code
        acta_nueva.version = acta.version
        acta_nueva.record_number = acta.record_number
        acta_nueva.area_process_committee = acta.area_process_committee
        acta_nueva.objective_meeting = acta.objective_meeting
        acta_nueva.meeting_type = acta.meeting_type
        acta_nueva.place = acta.place
        acta_nueva.order_day = acta.order_day
        acta_nueva.Issues = acta.Issues
        acta_nueva.miscellaneous_propositions = acta.miscellaneous_propositions
        acta_nueva.elaborated = acta.elaborated
        acta_nueva.entity_id = acta.entity_id
        acta_nueva.user_id = Current.user.id
        acta_nueva.evaluation_id = acta.evaluation_id
        acta_nueva.save
    end    
 

end
