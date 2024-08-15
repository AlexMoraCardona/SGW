class Indicator < ApplicationRecord
    belongs_to :cycle

    def self.label_periodicidad(dato)
        if dato == 0 ; 'Mensual'
        elsif dato == 1 ; 'Bimestral'
        elsif dato == 2 ; 'Trimestral'
        elsif dato == 3 ; 'Semestral'
        elsif dato == 4 ; 'Anual'
        elsif dato == 5 ; 'Diaria'
        end 
    end  

end
