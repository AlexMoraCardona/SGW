class SafetyInspection < ApplicationRecord
    belongs_to :entity

    def name_user(user_id)
        name = 'No encontrado'
        user =  User.find(user_id)
        name = user.name
        return  name 
    end
    
    def label_firm(firm)
        if firm == 0 ; 'NO'
        elsif  firm == 1 ; 'SI'
        end 
    end   
    
    def  self.buscar_safetys(entity)
        @safety_inspections =  SafetyInspection.where("entity_id = ?",entity)
    end   
    
end
