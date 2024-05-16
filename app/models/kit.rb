class Kit < ApplicationRecord
    has_many_attached :kit_fotos
    belongs_to :user
    belongs_to :entity

    def self.label_type_kit(dato)
        if dato == 0 ; 'Tipo A'
        elsif dato == 1 ; 'Tipo B'
        elsif dato == 2 ; 'Tipo C'
        end 
    end   
 
    def self.label_clasification_kit(dato)
        if dato == 0 ; 'Portátil'
        elsif dato == 1 ; 'Fijo'
        end 
    end      

    def self.label_obs(dato)
        if dato == 0 ; 'N/A'
        elsif dato == 1 ; 'SI'
        elsif dato == 2 ; 'NO'
        end 
    end      


end
