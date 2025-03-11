class Commitment < ApplicationRecord
    belongs_to :evidence
    belongs_to :user


     def self.state_commitment(dato)
        if dato == 0 ; 'Pendiente'
        elsif  dato == 1 ; 'Ejecutado'
        end 
    end  
end
