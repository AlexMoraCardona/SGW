class DetailDisease < ApplicationRecord
    belongs_to :table_disease

    def self.ransackable_attributes(auth_object = nil)
        ["name"]
    end  
    
    def self.label_name_disease(dato)
        nombre = DetailDisease.find(dato).name
        return nombre;
    end   
    

end
