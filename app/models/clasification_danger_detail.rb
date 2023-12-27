class ClasificationDangerDetail < ApplicationRecord
    belongs_to :clasification_danger

    def self.buscar_name(dato)
        result = ''
        result = ClasificationDangerDetail.find(dato).name
        return  result 
    end    

    def self.buscar_name_clasificacion(dato)
        result = ''
        result = ClasificationDangerDetail.find(dato).clasification_danger_id
        result = ClasificationDanger.find(result).name
        return  result 
    end    
end
