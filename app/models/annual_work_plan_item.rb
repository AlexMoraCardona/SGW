class AnnualWorkPlanItem < ApplicationRecord
    has_many_attached :observation_evidences


    def label_earring(dato)
        result = 'Planeado'
        if dato == 1 then
            result = 'Ejecutado'
        end    
        return  result 
    end    
end
