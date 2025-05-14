class DetailDisease < ApplicationRecord
    belongs_to :table_disease

    def self.ransackable_attributes(auth_object = nil)
        ["name"]
    end  
    
    def self.label_name_disease(dato)
        if dato == 0
            nombre = 'Sin clasificar'
        else    
            detaildisease = DetailDisease.find_by(id: dato)
            if detaildisease.present?
               nombre = detaildisease.name
            else
               nombre = 'Sin clasificar'
            end        
        end    
        return nombre;
    end   
    

end
