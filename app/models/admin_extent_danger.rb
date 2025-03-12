class AdminExtentDanger < ApplicationRecord
    belongs_to :entity
    belongs_to :user
    has_many   :danger_detail_risks
    has_many   :danger_preventions 
    has_many :form_preventions

    def label_state_extent(dato)
        if dato == 0 ; 'Inactivo'
        elsif dato == 1 ; 'Activo'
        end 
    end 

    def self.label_type_contract(dato)
        if dato == 0 ; 'Vinculado'
        elsif dato == 1 ; 'Prestación de servicios'
        end 
    end 

    def self.label_received_training(dato)
        if dato == 0 ; 'No'
        elsif dato == 1 ; 'Si'
        end 
    end 

    def self.label_suffered_accident(dato)
        if dato == 0 ; 'No'
        elsif dato == 1 ; 'Si'
        end 
    end   
    
    def self.label_epp(dato)
        if dato == 0 ; 'No'
        elsif dato == 1 ; 'Si'
        end 
    end   
    
end
