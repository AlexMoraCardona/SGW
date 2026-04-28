class CheckList < ApplicationRecord
    def self.label_state(dato)
        if dato == 0 ; 'Activo'
        elsif  dato == 1 ; 'Inactivo'
        end 
    end 
end
