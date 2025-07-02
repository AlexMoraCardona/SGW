class ProtectionElement < ApplicationRecord
    has_one_attached :img_elem
    has_one_attached :img_ficha
    has_many :epp_recuests

    def self.label_state_protection(dato)
        if dato == 0 ; 'No'
        elsif dato == 1 ; 'Si'
        end 
    end 

    def self.ransackable_attributes(auth_object = nil)
        ["entity"]
    end 

    
end
