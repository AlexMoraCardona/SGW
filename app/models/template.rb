class Template < ApplicationRecord
    has_one_attached :file
    belongs_to :standar_detail_item

    def self.label_state(dato)
        if dato == 0 ; 'INACTIVO'
        elsif  dato == 1 ; 'ACTIVO'
        end 
    end 

    def label_state(dato)
        if dato == 0 ; 'INACTIVO'
        elsif  dato == 1 ; 'ACTIVO'
        end 
    end   

    def self.ransackable_attributes(auth_object = nil)
                ["id", "name", "reference", "description", "standar_detail_item_id", "file", "date", "version", "state", "date_updated", "format_number", "filing"]
    end 

    def self.ransackable_associations(auth_object = nil)
        []
    end 

    def self.label_proceso(dato)
        if dato == 0 ; 'SG-SST'
        end 
    end  

    def self.label_tipodocumento(dato)
        if dato == 0 ; 'Acta'
        elsif dato == 1 ; 'Informe'
        elsif dato == 2 ; 'Encuesta'
        end 
    end  

    def self.label_tiposoporte(dato)
        if dato == 0 ; 'Físico'
        elsif dato == 1 ; 'Electrónico'
        elsif dato == 2 ; 'Híbrido'
        end 
    end  
    
    def self.label_dependencia_admin(dato)
        if dato == 0 ; 'SG-SST'
        end 
    end  

    def self.label_document_vigente(dato)
        if dato == 0 ; 'No vigente'
        elsif  dato == 1 ; 'Vigente'
        end 
    end  

    
end
