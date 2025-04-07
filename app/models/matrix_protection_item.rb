class MatrixProtectionItem < ApplicationRecord
    belongs_to :matrix_protection
    belongs_to :protection_element

    def self.label_state_protection(dato)
        if dato == 0 ; 'N/A'
        elsif  dato == 1 ; 'Servicios Generales'
        elsif  dato == 2 ; 'Odontólogo / Auxiliar de Odontología'
        elsif  dato == 3 ; 'Operarios'
        elsif  dato == 4 ; 'Taller Metalmecánica'
        elsif  dato == 5 ; 'Metalmecánica (DUBBER)'
        elsif  dato == 6 ; 'Producción'
        elsif  dato == 7 ; 'Terminada'
        elsif  dato == 8 ; 'Molino'
        elsif  dato == 9 ; 'Mantenimiento'
        elsif  dato == 10 ; 'Caucho'
        elsif  dato == 11 ; 'Mensajero'
        end 
    end

    def self.label(dato)
        if dato == 0 ; 'N/A'
        elsif  dato == 1 ; 'NO'
        elsif  dato == 2 ; 'SI'
        end 
    end
    
end
