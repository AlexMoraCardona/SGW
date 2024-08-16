class Event < ApplicationRecord
    belongs_to :entity
    belongs_to :user

    def self.labelsino(dato)
        if dato == 0 ; 'NO'
        elsif dato == 1 ; 'SI'
        end 
    end 

    def self.ransackable_attributes(auth_object = nil)
        ["date_new", "user_id", "entity_id", "work_accident", "mortal_accident", "occupational_disease",]
    end 

end
