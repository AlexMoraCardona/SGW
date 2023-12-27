class HistoryMatrixLegalItem < ApplicationRecord
    has_one_attached :attach_evidence

    def label_apply(apply)
        if apply == 0 ; 'NO APLICA'
        elsif apply == 1 ; 'SI APLICA'
        end 
    end    

    def label_meets(meets)
        if meets == 0 ; 'NO (0%)'
        elsif meets == 1 ; 'PARCIAL (50%)'
        elsif meets == 2 ; 'SI (100%)'
        end 
    end  
    

end
