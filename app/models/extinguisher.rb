class Extinguisher < ApplicationRecord
    has_many_attached :extinguisher_fotos
    belongs_to :adm_extinguisher

    def self.label(dato)
        if dato == 0 ; 'NA'
        elsif dato == 1 ; 'NT'
        elsif dato == 2 ; 'B'
        elsif dato == 3 ; 'M'
        end 
    end  
  
    def self.label_type(dato)
        if dato == 0 ; 'Extintor H2O'
        elsif dato == 1 ; 'Extintor CO2'
        elsif dato == 2 ; 'Extintor Multiproposito ABC'
        elsif dato == 3 ; 'Extintor Solkaflam'
        elsif dato == 4 ; 'Extintor Clase D'
        elsif dato == 5 ; 'Extintor Tipo K'
        end 
    end      
end

