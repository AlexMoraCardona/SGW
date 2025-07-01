class EppRecuest < ApplicationRecord
    belongs_to :entity
    belongs_to :user
    belongs_to :protection_element
    
    def self.label_state_recuest(dato)
        if dato == 0 ; 'Pendiente'
        elsif dato == 1 ; 'Gestionado'
        end 
    end 

    def self.ransackable_attributes(auth_object = nil)
        ["user_id", "state_recuest", "entity_id"]
    end 
    
end
