class AnnualWorkPlanItem < ApplicationRecord
    has_many_attached :observation_evidences


    def label_earring(dato)
        result = 'P'
        if dato == 1 then
            result = 'E'
        end    
        return  result 
    end    
end
