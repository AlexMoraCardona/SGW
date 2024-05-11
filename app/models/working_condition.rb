class WorkingCondition < ApplicationRecord
    belongs_to :entity
    belongs_to :user
    has_many :working_condition_items

    def self.label_estado(dato)
        if dato == 0 ; 'Soltero'
        elsif  dato == 1 ; 'Casado'
        elsif  dato == 2 ; 'Unión Libre'
        elsif  dato == 3 ; 'Separado'
        end 
    end  



end
