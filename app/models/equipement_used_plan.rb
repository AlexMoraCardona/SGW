class EquipementUsedPlan < ApplicationRecord
    belongs_to :emergency_plan


    def self.label_type_equipement(dato)
        if dato == 0 ; 'Herramientas eléctricas'
        elsif dato == 1 ; 'Herramientas manuales'
        end 
    end 

    
end
