class ClasificationDanger < ApplicationRecord
    has_many :clasification_danger_details

    def self.buscar_name(dato)
        result = ''
        result = ClasificationDanger.find(dato).name
        return  result 
    end    
end
