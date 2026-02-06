class InternalReport < ApplicationRecord
    belongs_to :entity
    has_many_attached :imagenes_reports

    def self.label_type_report(dato)
        if dato == 0 ; 'INCIDENTE'
        elsif  dato == 1 ; 'ACCIDENTE'
        elsif  dato == 2 ; 'ACCIDENTE GRAVE'
        elsif  dato == 3 ; 'ACCIDENTE MORTAL'
        end 
    end  
end
