class Presentation < ApplicationRecord
    has_one_attached :archivo

    def self.label_entity(dato)
        name = "No encontrado"
        name =  Entity.find(dato).business_name
        return name;
    end    
end
