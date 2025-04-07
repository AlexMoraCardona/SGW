class Standar < ApplicationRecord
    has_many :standar_details
    belongs_to :rule


    def label_cycle(cycle)
        if cycle == 1 ; 'Planear'
        elsif cycle == 2 ; 'Hacer'
        elsif cycle == 3 ; 'Verificar'
        elsif cycle == 4 ; 'Actuar'
        end 
    end

end
