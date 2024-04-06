class OccupationalExamItem < ApplicationRecord
    belongs_to :occupational_exam

    def label_exam_type(dato)
        if dato == 0 ; 'Preingreso'
        elsif  firm == 1 ; 'Periódicos'
        elsif  firm == 2 ; 'Egreso'
        end 
    end     
end
