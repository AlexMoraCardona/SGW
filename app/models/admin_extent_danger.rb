class AdminExtentDanger < ApplicationRecord
    belongs_to :entity
    has_many   :danger_detail_risks
    has_many   :danger_preventions 
    has_many :form_preventions

    def label_state_extent(dato)
        if dato == 0 ; 'Inactivo'
        elsif dato == 1 ; 'Activo'
        end 
    end 

    
end
