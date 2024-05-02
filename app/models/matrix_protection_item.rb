class MatrixProtectionItem < ApplicationRecord
    belongs_to :matrix_protection
    belongs_to :protection_element

    def self.label_state_protection(dato)
        if dato == 0 ; 'N/A'
        elsif  dato == 1 ; 'Servicios Generales'
        elsif  dato == 2 ; 'Odontólogo / Auxiliar de Odontología'
        elsif  dato == 3 ; 'Operarios'
        end 
    end

    def self.label(dato)
        if dato == 0 ; 'N/A'
        elsif  dato == 1 ; 'NO'
        elsif  dato == 2 ; 'SI'
        end 
    end
    
end
