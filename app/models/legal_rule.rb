class LegalRule < ApplicationRecord

    def self.label_clasification_norma(dato)
        if dato == 0 ; 'Genérica'
        elsif dato == 1 ; 'Específica'
        end 
    end   

end
