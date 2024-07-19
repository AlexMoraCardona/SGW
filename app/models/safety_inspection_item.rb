class SafetyInspectionItem < ApplicationRecord
    has_many_attached :inspection_evidences
    belongs_to :safety_inspection
    belongs_to :situation_condition

    def self.label_state_compliance(dato)
        if dato == 0 ; 'N/A'
        elsif  dato == 1 ; 'SI'
        elsif  dato == 2 ; 'NO'
        elsif  dato == 3 ; 'PARCIAL'
        end 
    end     

end
