class OccupationalExamItem < ApplicationRecord
    belongs_to :occupational_exam

    def label_exam_type(dato)
        if dato == 0 ; 'Ingreso'
        elsif  dato == 1 ; 'Periódicos'
        elsif  dato == 2 ; 'Egreso'
        end 
    end 

    
    def self.label_state_exam(dato)
        if dato == 0 ; 'Pendiente'
        elsif  dato == 1 ; 'Realizado'
        elsif  dato == 2 ; 'Cancelado'
        end 
    end 
end
