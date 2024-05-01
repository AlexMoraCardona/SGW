class ProtectionElement < ApplicationRecord
    has_one_attached :img_elem

    def self.label_state_protection(dato)
        if dato == 0 ; 'No'
        elsif dato == 1 ; 'Si'
        end 
    end 
    
end
